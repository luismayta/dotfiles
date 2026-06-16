## MODIFIED Requirements

### Requirement: Container-app abstraction

#### Scenario: Container-app dispatch — docker (Linux)
- **WHEN** `DOCKER_CONTAINER_APP_NAME` is `docker` **AND** `OSTYPE` is `linux*`
- **THEN** the module SHALL install docker and docker-compose via `core::install` (which delegates to `paru` on Arch Linux)
- **AND** it SHALL enable and start docker via `sudo systemctl enable --now docker`
- **AND** it SHALL add the current user to the `docker` group via `sudo usermod -aG docker $USER`
- **AND** it SHALL verify the installation via `docker run hello-world`
- **AND** it SHALL set `docker::internal::container::load` as a no-op

#### Scenario: Container-app dispatch — docker (macOS)
- **WHEN** `DOCKER_CONTAINER_APP_NAME` is `docker` **AND** `OSTYPE` is `darwin*`
- **THEN** the module SHALL install docker via the shared `install::provider` helper (using `core::install`)
- **AND** it SHALL set `docker::internal::container::load` as a no-op
