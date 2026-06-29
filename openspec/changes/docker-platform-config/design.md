## Context

The Docker ZSH module (`zsh/modules/docker/`) uses a 3-layer architecture — `config/`, `internal/`, `pkg/` — with a provider pattern dispatching on `DOCKER_CONTAINER_APP_NAME`. Currently:

- `config/base.zsh` hardcodes `DOCKER_CONTAINER_APP_NAME="${JASPER_CONTAINER_APP_NAME:-orbstack}"`, which is macOS-only
- There is zero OS detection logic anywhere in the module — the standard convention requires `config/osx.zsh` / `config/linux.zsh` at each layer (see `docs/guides/create-module.md`)
- All four provider config files (`colima.zsh`, `lima.zsh`, `orbstack.zsh`, `podman.zsh`) are empty stubs
- `internal/docker.zsh` mixes macOS Docker Desktop and Linux systemd logic in one file — should be split into `internal/osx.zsh` / `internal/linux.zsh`
- No `DOCKER_HOST` resolution exists — each provider is responsible for its own socket path

This makes the module unreliable on Linux and unable to adapt when the user switches between macOS and Linux environments.

## Goals / Non-Goals

**Goals:**
- Detect macOS vs Linux at module load and set appropriate platform defaults
- Auto-select a sensible default provider per platform: `orbstack` on macOS, `docker` (native) on Linux
- Populate all four provider config stubs with platform-aware defaults
- Add `DOCKER_HOST` auto-resolution based on active provider
- Add Docker health-check at module load
- Support macOS Docker Desktop (alongside Orbstack and Colima)
- Support Linux rootless Docker mode detection

**Non-Goals:**
- Windows (WSL) support — out of scope for now
- Remote Docker hosts (Docker contexts) — not part of this change
- Docker daemon configuration file generation (`daemon.json`)
- CI/CD-specific Docker configuration

## Decisions

| Decision | Choice | Rationale |
|---|---|---|---|
| **OS detection method** | `$OSTYPE` (zsh built-in) in `config/main.zsh` dispatch | Already used in `internal/docker.zsh`; no external dependency needed. Matches the standard module convention from `docs/guides/create-module.md` — `osx.zsh` / `linux.zsh` in every layer |
| **OS file naming** | `osx.zsh` / `linux.zsh` per layer (not `os.zsh`) | Follows the documented standard from `create-module.md` Section 6; makes the platform contract explicit in every layer |
| **Default provider per OS** | macOS → `orbstack`, Linux → `docker` | Orbstack is the most seamless macOS experience; native Docker (systemd) is standard on Linux. User can override via `DOCKER_CONTAINER_APP_NAME` |
| **Provider config file structure** | Each provider file exports env vars + provider-specific defaults | Follows existing pattern; allows user overrides before module load |
| **DOCKER_HOST resolution** | New function `docker::internal::resolve::socket` in `internal/base.zsh` | Centralizes socket path logic; each provider registers its path during config |
| **Health check approach** | `docker info` with timeout and graceful fallback | Non-blocking warning on failure — don't prevent shell load |
| **macOS Docker Desktop detection** | Check for `Docker.app` bundle + `~/.docker/run/docker.sock` (in `config/osx.zsh`) | Standard path for Docker Desktop on macOS; fallback to `docker context inspect` |
| **Linux rootless detection** | Check for `$XDG_RUNTIME_DIR/docker.sock` (in `config/linux.zsh`) | Rootless Docker uses user-scoped socket paths instead of `/var/run/docker.sock` |
| **internal/docker.zsh scope** | Renamed to macOS Docker Desktop only; Linux CE moves to `internal/linux.zsh` | Cleans up the mixed OS logic currently in one file; each OS has its own internal file per convention |

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| `$OSTYPE` may not cover niche cases (WSL, NixOS) | Add explicit detection for WSL via `/proc/version`; NixOS users can override provider manually |
| Adding DOCKER_HOST resolution could break existing setups | Only set `DOCKER_HOST` if not already defined by user; respect explicit overrides |
| Health check adds latency to shell load | Run health check asynchronously (background job); only emit warning if failed after 500ms timeout |
| Provider configs may grow stale as tools evolve | Keep configs minimal (paths only); move complex logic to internal/ layer |
