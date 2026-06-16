## ADDED Requirements

### Requirement: Docker module structure
The system SHALL provide a docker module at `zsh/modules/docker/` following the modules convention established by `zsh/modules/rust/`.

#### Scenario: Module directory structure
- **WHEN** the module is created
- **THEN** it SHALL contain a `plugin.zsh` entry point with idempotency guard (`__ZSH_DOCKER_LOADED`)
- **AND** it SHALL contain `config/`, `internal/`, and `pkg/` subdirectories
- **AND** `config/main.zsh` SHALL perform OS-type dispatch and container-app dispatch
- **AND** `internal/main.zsh` SHALL perform OS-type dispatch and container-app dispatch
- **AND** `pkg/main.zsh` SHALL perform OS-type dispatch and source `pkg/base.zsh`, `pkg/helper.zsh`, and `pkg/alias.zsh`

### Requirement: Container-app abstraction
The module SHALL support multiple container runtimes via the `DOCKER_CONTAINER_APP_NAME` environment variable.

#### Scenario: Container-app dispatch — orbstack (default)
- **WHEN** `DOCKER_CONTAINER_APP_NAME` is `orbstack` (or unset)
- **THEN** the module SHALL source `config/orbstack.zsh` which defines `container::core` as `alias docker=docker`
- **AND** it SHALL source `internal/orbstack.zsh` which provides `container::internal::container::install` (install orbstack via brew) and `container::internal::container::load` (no-op)

#### Scenario: Container-app dispatch — colima
- **WHEN** `DOCKER_CONTAINER_APP_NAME` is `colima`
- **THEN** the module SHALL source `config/colima.zsh` which defines `container::core` as `alias docker=docker`
- **AND** it SHALL source `internal/colima.zsh` which provides `container::internal::container::install` (install colima + docker via brew) and `container::internal::container::load` (verify jq + colima status, start if not running)

#### Scenario: Container-app dispatch — lima
- **WHEN** `DOCKER_CONTAINER_APP_NAME` is `lima`
- **THEN** the module SHALL source `config/lima.zsh` which defines `container::core` as `alias docker='limactl shell default nerdctl'`
- **AND** it SHALL source `internal/lima.zsh` which provides `container::internal::container::install` (install lima via brew) and `container::internal::container::load` (verify jq + limactl, check/create/start lima machine)

#### Scenario: Container-app dispatch — podman
- **WHEN** `DOCKER_CONTAINER_APP_NAME` is `podman`
- **THEN** the module SHALL source `config/podman.zsh` which defines `container::core` as `alias docker=podman`
- **AND** it SHALL source `internal/podman.zsh` which provides `container::internal::container::install` (install podman via brew) and `container::internal::container::load` (verify jq, check/create/start podman machine)

#### Scenario: Container-app dispatch — docker (macOS)
- **WHEN** `DOCKER_CONTAINER_APP_NAME` is `docker` **AND** `OSTYPE` is `darwin*`
- **THEN** the module SHALL install docker via the shared `install::provider` helper (using `core::install`)
- **AND** it SHALL set `docker::internal::container::load` as a no-op

#### Scenario: Container-app dispatch — docker (Linux)
- **WHEN** `DOCKER_CONTAINER_APP_NAME` is `docker` **AND** `OSTYPE` is `linux*`
- **THEN** the module SHALL install docker and docker-compose via `core::install` (which delegates to `paru` on Arch Linux)
- **AND** it SHALL enable and start docker via `sudo systemctl enable --now docker`
- **AND** it SHALL add the current user to the `docker` group via `sudo usermod -aG docker $USER`
- **AND** it SHALL verify the installation via `docker run hello-world`
- **AND** it SHALL set `docker::internal::container::load` as a no-op

### Requirement: Core docker management functions
The module SHALL provide internal functions for docker lifecycle management.

#### Scenario: Docker login
- **WHEN** `docker::internal::login` is called
- **THEN** it SHALL read `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` environment variables and pipe the token to `docker login`

#### Scenario: Clean all docker resources
- **WHEN** `docker::internal::clean::all` is called
- **THEN** it SHALL run `docker system prune --all --force --volumes`

#### Scenario: Image management
- **WHEN** `docker::internal::images::delete::dangling` is called
- **THEN** it SHALL remove all dangling (untagged) images

#### Scenario: Process management
- **WHEN** `docker::internal::process::stop::all` is called
- **THEN** it SHALL stop all running containers

#### Scenario: Volume management
- **WHEN** `docker::internal::volume::delete::all` is called
- **THEN** it SHALL remove all docker volumes

#### Scenario: Container management
- **WHEN** `docker::internal::container::delete::all` is called
- **THEN** it SHALL stop and remove all containers

#### Scenario: Network management
- **WHEN** `docker::internal::network::delete::all` is called
- **THEN** it SHALL remove all docker networks

### Requirement: Public API layer
The module SHALL expose a public API through `pkg/base.zsh` that wraps internal functions.

#### Scenario: Public wrappers
- **WHEN** the module is loaded
- **THEN** it SHALL expose `docker::login`, `docker::clean::all`, `docker::clean::dangling`, `docker::clean::images::all`, `docker::clean::images::dangling`, `docker::clean::process::all`, `docker::clean::process::dangling`, `docker::clean::volume::all`, `docker::clean::volume::dangling`, `docker::clean::network::all`, `docker::clean::network::dangling`, `docker::process::list`, `docker::process::stop::all`, `docker::process::stop::exited`, `docker::process::delete::all`, `docker::volume::delete::all`, `docker::volume::list::all`, `docker::volume::delete::exited`, `docker::volume::delete::dangling`, `docker::container::delete::all`, `docker::container::stop::all`, `docker::container::delete::dangling`, `docker::network::delete::all`, `docker::images::delete::dangling`, `docker::images::delete::all`

### Requirement: Docker CLI aliases
The module SHALL provide shorthand docker aliases through `pkg/alias.zsh`.

#### Scenario: Alias definitions
- **WHEN** the module is loaded
- **THEN** the following aliases SHALL be defined: `d` (docker), `di` (docker images), `drmi` (docker rmi), `dbu` (docker build), `dps` (docker ps), `drm` (docker rm), `dexec` (docker exec), `dlog` (docker logs)

### Requirement: Docker CLI wrappers (from devops migration)
The module SHALL include docker-based CLI wrappers migrated from `zsh/modules/devops/pkg/docker.zsh`.

#### Scenario: CLI wrapper functions
- **WHEN** the module is loaded
- **THEN** the following wrapper functions SHALL be available: `awscli` (docker run awscli), `aws-shell` (docker run aws-shell), `nyancat` (docker run nyancat), `ytd-mp3` (docker run youtube-dl extract audio), `ytdl` (docker run youtube-dl), `youtube-dl` (docker run youtube-dl), `komiser` (docker run komiser)

### Requirement: Auto-install on load
The module SHALL auto-install docker (or the configured container app) if not already present.

#### Scenario: Auto-install at module load
- **WHEN** the module is sourced
- **THEN** the module SHALL check if the configured container app binary exists
- **AND** if missing, it SHALL install it via `core::install` (brew)
- **AND** it SHALL then run the container app's load function (start the runtime if needed)

### Requirement: Devops docker.zsh removal
The legacy `zsh/modules/devops/pkg/docker.zsh` SHALL be removed and its source line removed from `zsh/modules/devops/pkg/main.zsh`.

#### Scenario: Devops cleanup
- **WHEN** the migration is complete
- **THEN** `zsh/modules/devops/pkg/docker.zsh` SHALL be deleted
- **AND** `zsh/modules/devops/pkg/main.zsh` SHALL no longer source `${DEVOPS_PATH}/pkg/docker.zsh`

### Requirement: Namespace consistency
All module variables SHALL use the `DOCKER_*` prefix (not `ZSH_DOCKER_*`).

#### Scenario: Variable renaming
- **WHEN** the module is loaded
- **THEN** `DOCKER_PATH` SHALL be set to the module's root directory
- **AND** `DOCKER_PACKAGE_NAME` SHALL be `docker`
- **AND** `DOCKER_CONTAINER_APP_NAME` SHALL default to the value of `JASPER_CONTAINER_APP_NAME` or `orbstack`
- **AND** `DOCKER_PODMAN_MACHINE_NAME` SHALL be `podman-machine-default`
- **AND** `DOCKER_LIMA_MACHINE_NAME` SHALL be `default`