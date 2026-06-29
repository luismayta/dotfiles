## ADDED Requirements

### Requirement: Systemd service management
When the host OS is Linux and the active provider is `docker`, the system SHALL ensure the Docker systemd service is enabled and running.

#### Scenario: Docker service not enabled
- **WHEN** `systemctl is-enabled docker` returns non-zero on Linux
- **THEN** the system SHALL run `sudo systemctl enable docker` and emit an info message

#### Scenario: Docker service not running
- **WHEN** `systemctl is-active docker` returns non-zero on Linux
- **THEN** the system SHALL run `sudo systemctl start docker` and emit an info message

#### Scenario: User not in docker group
- **WHEN** `groups` does not include `docker` on Linux
- **THEN** the system SHALL emit a warning: "User not in docker group — run: sudo usermod -aG docker ${USER}"

#### Scenario: Non-systemd Linux
- **WHEN** `systemctl` is not available on Linux
- **THEN** the system SHALL skip systemd operations and emit a debug message

### Requirement: Rootless Docker support
On Linux, the system SHALL detect rootless Docker mode and use user-scoped socket paths accordingly.

#### Scenario: Rootless Docker detected
- **WHEN** `$XDG_RUNTIME_DIR/docker.sock` exists (typically `/run/user/${UID}/docker.sock`)
- **THEN** the system SHALL prefer the rootless socket path over `/var/run/docker.sock`

#### Scenario: Rootless socket set as DOCKER_HOST
- **WHEN** rootless mode is detected and `DOCKER_HOST` is not already set
- **THEN** `DOCKER_HOST` SHALL be set to `unix://${XDG_RUNTIME_DIR}/docker.sock`

### Requirement: Docker Compose installation check
On Linux, the system SHALL verify that `docker-compose` (plugin or standalone) is available.

#### Scenario: Docker compose plugin available
- **WHEN** `docker compose version` succeeds (plugin)
- **THEN** the system SHALL set `DOCKER_COMPOSE_TYPE=plugin`

#### Scenario: Standalone docker-compose available
- **WHEN** `docker-compose --version` succeeds (standalone)
- **THEN** the system SHALL set `DOCKER_COMPOSE_TYPE=standalone`

#### Scenario: No compose available
- **WHEN** neither `docker compose` nor `docker-compose` is found
- **THEN** the system SHALL emit a warning: "docker-compose not found — install via: sudo apt install docker-compose-plugin"
