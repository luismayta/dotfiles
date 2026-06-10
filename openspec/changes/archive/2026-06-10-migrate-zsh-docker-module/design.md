## Context

Docker tooling currently exists in two places:
1. **External repo** `hadenlabs/zsh-docker` — a complete module with config/, internal/, and pkg/ layers supporting multiple container apps (colima, lima, podman, docker, orbstack) via `ZSH_DOCKER_CONTAINER_APP_NAME` env var dispatch.
2. **Devops module** `zsh/modules/devops/pkg/docker.zsh` — a legacy file containing docker-based CLI wrappers (`awscli`, `nyancat`, `ytdl`, `komiser`, etc.).

All other dotfiles modules (rust, tmux, git, ghq, etc.) follow a consistent convention established by `zsh/modules/rust/`: `plugin.zsh` entry point with idempotency guard, config/ → internal/ → pkg/ sourcing chain, OS dispatch via `case "${OSTYPE}"`, and module root path variable.

This change migrates the hadenlabs/zsh-docker repo into this convention, creating `zsh/modules/docker/` and removing the redundant devops docker file.

## Goals / Non-Goals

**Goals:**
- Create `zsh/modules/docker/` with the same structure as `zsh/modules/rust/`
- Preserve all container-app abstractions (colima, lima, podman, docker, orbstack)
- Remove `zsh/modules/devops/pkg/docker.zsh` and its source line in devops pkg/main.zsh
- Adapt the external repo's namespace (`ZSH_DOCKER_*` → `DOCKER_*`, function naming convention)
- Auto-source the new module via zshrc module loader convention

**Non-Goals:**
- Not modifying the upstream `hadenlabs/zsh-docker` repo — it stays as reference
- Not changing behavior of existing docker CLI wrappers (awscli, ytdl, etc.)
- Not adding new container-app providers beyond the five already supported

## Decisions

### Decision 1: Module structure follows rust/ convention exactly
**Why**: Consistency across all modules simplifies maintenance. The rust module was already ported from an external repo (hadenlabs/zsh-rust) and is the canonical example.

Structure:
```
zsh/modules/docker/
├── plugin.zsh           # Entry point with __ZSH_DOCKER_LOADED guard
├── config/
│   ├── main.zsh         # OS dispatch (OS type) + container-app dispatch
│   ├── base.zsh         # Env vars: DOCKER_* variables
│   ├── orbstack.zsh     # container::core for orbstack
│   ├── colima.zsh       # container::core for colima
│   ├── lima.zsh         # container::core for lima
│   ├── podman.zsh       # container::core for podman
│   ├── docker.zsh       # container::core for docker
│   ├── osx.zsh
│   └── linux.zsh
├── internal/
│   ├── main.zsh         # OS dispatch + container-app dispatch + helper
│   ├── base.zsh         # Core functions: login, clean, images, process, volume, container, network
│   ├── orbstack.zsh     # Install/load for Orbstack
│   ├── colima.zsh       # Install/load for Colima
│   ├── lima.zsh         # Install/load for Lima
│   ├── podman.zsh       # Install/load for Podman
│   ├── docker.zsh       # Install/load for Docker
│   ├── osx.zsh
│   ├── linux.zsh
│   └── helper.zsh
└── pkg/
    ├── main.zsh         # OS dispatch + helper + alias
    ├── base.zsh         # Public API: docker::login, clean, images, etc.
    ├── alias.zsh        # Aliases: d, di, drmi, dbu, dps, drm, dexec, dlog
    ├── helper.zsh
    ├── osx.zsh
    └── linux.zsh
```

### Decision 2: Namespace renamed from ZSH_DOCKER_* to DOCKER_*
**Why**: The modules convention uses short module root vars (`RUST_PATH`, `DEVOPS_PATH`) and env vars without the `ZSH_` prefix. This eliminates the `ZSH_` prefix throughout.

| Old (hadenlabs/zsh-docker) | New (modules/docker/) |
|---|---|
| `ZSH_DOCKER_PATH` | `DOCKER_PATH` |
| `ZSH_DOCKER_PACKAGE_NAME` | `DOCKER_PACKAGE_NAME` |
| `ZSH_DOCKER_CONTAINER_APP_NAME` | `DOCKER_CONTAINER_APP_NAME` |
| `ZSH_DOCKER_PODMAN_MACHINE_NAME` | `DOCKER_PODMAN_MACHINE_NAME` |
| `ZSH_DOCKER_LIMA_MACHINE_NAME` | `DOCKER_LIMA_MACHINE_NAME` |
| `ZSH_DOCKER_MESSAGE_*` | `DOCKER_MESSAGE_*` |

### Decision 3: Remove factory functions, use module-level sourcing
**Why**: The external repo uses inline factory functions (`docker::config::main::factory`, `docker::internal::main::factory`, `docker::pkg::main::factory`) that are called immediately. The modules convention sources files directly. The OS + container-app dispatch logic moves into the respective `main.zsh` files as `case` blocks, same as `zsh/modules/rust/`.

### Decision 4: Auto-install moves from internal/main.zsh to pkg/base.zsh
**Why**: The rust module triggers auto-install at the bottom of pkg/base.zsh (`if ! core::exists rustc; then ...`). The docker module should follow the same pattern — move the `container::internal::container::install` and `container::internal::container::load` calls from `internal/main.zsh` to the bottom of `pkg/base.zsh`.

### Decision 5: Keep container-app abstraction
**Why**: The `DOCKER_CONTAINER_APP_NAME` env var (default: `orbstack`) allows users to switch between colima, lima, podman, docker, and orbstack without changing their dotfiles. This is valuable functionality that the modules convention supports naturally via its OS-type dispatch pattern — extended here to include container-app dispatch.

### Decision 6: Docker CLI wrappers (awscli, ytdl, etc.) stay in the docker module
**Why**: The devops docker.zsh contains docker-based CLI wrappers that are docker-adjacent. They move to the docker module's pkg layer (pkg/base.zsh) alongside the other docker public API functions to keep docker concerns in one place.

**Alternatives considered:**
- Split wrappers into devops module as individual files: More files, more complexity, no clear benefit since all wrappers depend on docker.
- Keep wrappers in devops: Defeats the purpose of consolidating docker concerns.

## Risks / Trade-offs

- **[Breaking] Function namespace change**: Users sourcing `docker::*` functions directly will need to update references. Since these are internal dotfiles functions (not a public API), this is acceptable.
- **[Dependency] Docker must be installed**: The module depends on docker (or colima/lima/podman/orbstack). The auto-install logic handles this, but bootstrapping may fail if brew is not available.
- **[Regression] Devops docker.zsh removal**: The devops docker.zsh contains both docker management functions AND CLI wrappers (awscli, ytdl). Must ensure all are migrated before removal.
- **[Compatibility] JASPER_CONTAINER_APP_NAME**: The config uses `JASPER_CONTAINER_APP_NAME` as fallback for `DOCKER_CONTAINER_APP_NAME`. This dependency should be preserved for backward compatibility.
