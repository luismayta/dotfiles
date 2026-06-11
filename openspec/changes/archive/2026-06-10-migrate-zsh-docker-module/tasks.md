## 1. Scaffold module directory structure

- [x] 1.1 Create `zsh/modules/docker/` with subdirectories `config/`, `internal/`, `pkg/`
- [x] 1.2 Create `config/osx.zsh` and `config/linux.zsh` as empty stubs
- [x] 1.3 Create `internal/osx.zsh`, `internal/linux.zsh`, `internal/helper.zsh` as empty stubs
- [x] 1.4 Create `pkg/osx.zsh`, `pkg/linux.zsh`, `pkg/helper.zsh` as empty stubs

## 2. Create config layer

- [x] 2.1 Create `config/base.zsh` with env vars: `DOCKER_PATH`, `DOCKER_PACKAGE_NAME`, `DOCKER_CONTAINER_APP_NAME` (defaults to `JASPER_CONTAINER_APP_NAME` or `orbstack`), `DOCKER_PODMAN_MACHINE_NAME`, `DOCKER_LIMA_MACHINE_NAME`, and `DOCKER_MESSAGE_*` variables
- [x] 2.2 Create `config/docker.zsh` with `container::core` defining `alias docker=docker`
- [x] 2.3 Create `config/colima.zsh` with `container::core` defining `alias docker=docker`
- [x] 2.4 Create `config/lima.zsh` with `container::core` defining `alias docker='limactl shell default nerdctl'`
- [x] 2.5 Create `config/orbstack.zsh` with `container::core` defining `alias docker=docker`
- [x] 2.6 Create `config/podman.zsh` with `container::core` defining `alias docker=podman`
- [x] 2.7 Create `config/main.zsh` sourcing base.zsh, dispatching on OSTYPE (osx/linux), then dispatching on `DOCKER_CONTAINER_APP_NAME` (colima/lima/podman/docker/orbstack) sourcing the corresponding `config/<app>.zsh`, then calling `container::core`

## 3. Create internal layer

- [x] 3.1 Create `internal/base.zsh` with core functions: `docker::internal::login`, `docker::internal::clean::all`, `docker::internal::images::delete::dangling`, `docker::internal::images::delete::all`, `docker::internal::process::list`, `docker::internal::process::stop::all`, `docker::internal::process::stop::exited`, `docker::internal::process::delete::all`, `docker::internal::volume::list::all`, `docker::internal::volume::delete::exited`, `docker::internal::volume::delete::all`, `docker::internal::volume::delete::dangling`, `docker::internal::container::delete::all`, `docker::internal::container::stop::all`, `docker::internal::container::stop::dangling`, `docker::internal::network::delete::all`
- [x] 3.2 Create `internal/docker.zsh` with `container::internal::container::install` (install docker via brew) and `container::internal::container::load` (no-op)
- [x] 3.3 Create `internal/colima.zsh` with `container::internal::container::install` (install colima + docker via brew) and `container::internal::container::load` (check jq, verify colima status with `colima status --json`, start if not running)
- [x] 3.4 Create `internal/lima.zsh` with `container::internal::container::install` (install lima via brew) and `container::internal::container::load` (check jq, verify/start lima machine using `limactl list --json`)
- [x] 3.5 Create `internal/orbstack.zsh` with `container::internal::container::install` (install orbstack via brew) and `container::internal::container::load` (no-op)
- [x] 3.6 Create `internal/podman.zsh` with `container::internal::container::install` (install podman via brew) and `container::internal::container::load` (check jq, verify/start podman machine using `podman machine list --format json`)
- [x] 3.7 Create `internal/main.zsh` sourcing base.zsh, dispatching on OSTYPE (osx/linux), then dispatching on `DOCKER_CONTAINER_APP_NAME` sourcing the corresponding internal/<app>.zsh, then sourcing helper.zsh

## 4. Create public API layer

- [x] 4.1 Create `pkg/base.zsh` with all public wrapper functions: `docker::login`, `docker::clean::*`, `docker::process::*`, `docker::volume::*`, `docker::container::*`, `docker::network::*`, `docker::images::*`, and the docker CLI wrappers migrated from devops (`awscli`, `aws-shell`, `nyancat`, `ytd-mp3`, `ytdl`, `youtube-dl`, `komiser`)
- [x] 4.2 Create `pkg/alias.zsh` with docker aliases: `d`, `di`, `drmi`, `dbu`, `dps`, `drm`, `dexec`, `dlog`
- [x] 4.3 Create `pkg/main.zsh` sourcing base.zsh, dispatching on OSTYPE (osx/linux), then sourcing helper.zsh and alias.zsh

## 5. Create module entry point

- [x] 5.1 Create `plugin.zsh` with idempotency guard (`__ZSH_DOCKER_LOADED`), `DOCKER_PATH` variable, and sourcing chain: `config/main.zsh` → `internal/main.zsh` → `pkg/main.zsh`

## 6. Remove docker from devops module

- [x] 6.1 Delete `zsh/modules/devops/pkg/docker.zsh`
- [x] 6.2 Remove `source "${DEVOPS_PATH}/pkg/docker.zsh"` from `zsh/modules/devops/pkg/main.zsh`

## 7. Add auto-install logic

- [x] 7.1 Add auto-install block at the bottom of `pkg/base.zsh`: check if the configured container app binary exists, if not call `container::internal::container::install`, then call `container::internal::container::load`