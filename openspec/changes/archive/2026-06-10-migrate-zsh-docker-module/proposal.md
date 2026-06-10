## Why

The docker CLI wrappers and helpers currently live split across two locations: a standalone external repo (`hadenlabs/zsh-docker`) and a legacy file inside `zsh/modules/devops/pkg/docker.zsh`. This creates duplication, makes maintenance harder, and breaks the modules/ convention used by all other dotfiles modules (rust, tmux, git, etc.).

Migrating `hadenlabs/zsh-docker` into `zsh/modules/docker/` following the established convention (same structure as `zsh/modules/rust/`) consolidates docker management into a first-class module, removes the stale devops file, and aligns with the architecture of the rest of the dotfiles.

## What Changes

- **Migrate** `hadenlabs/zsh-docker` → `zsh/modules/docker/` following the `zsh/modules/rust/` structure convention
- **Remove** the docker CLI wrappers from `zsh/modules/devops/pkg/docker.zsh` (they move to the new module)
- **Restructure** the external repo's files (zsh-docker.zsh entry point → `plugin.zsh`; config/ internal/ pkg/ layers adapted to the modules convention)
- **Adapt** the container-app abstraction (colima, lima, podman, docker, orbstack) into the module's config/ and internal/ layers
- **Rename** namespace from `ZSH_DOCKER_*` to `DOCKER_*` and function namespace from `docker::*` to the standard module pattern
- **Add** idempotency guard (`__ZSH_DOCKER_LOADED`) in `plugin.zsh`

## Capabilities

### New Capabilities
- `docker-module`: Docker module for the dotfiles — provides container runtime management (install, load, lifecycle) for multiple container apps (colima, lima, podman, docker, orbstack), plus docker CLI wrappers, aliases, and cleanup utilities — all following the modules/ convention.

### Modified Capabilities
- `devops-tools`: Remove `docker.zsh` from devops module (docker CLI wrappers move to the dedicated docker module)

## Impact

- **New directory**: `zsh/modules/docker/` with config/, internal/, pkg/ layers
- **Deleted**: `zsh/modules/devops/pkg/docker.zsh` (functions move to new module)
- **Modified**: `zsh/modules/devops/pkg/main.zsh` (remove `source "${DEVOPS_PATH}/pkg/docker.zsh"`)
- **Source repo**: `hadenlabs/zsh-docker` will remain as upstream reference but the primary source moves into the dotfiles
- **Namespacing**: Internal functions adopt the `docker::internal::*` convention aligned with the modules architecture
