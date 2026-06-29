## ADDED Requirements

### Requirement: Provider availability detection
The system SHALL check whether each known container runtime binary is available and export a `DOCKER_AVAILABLE_PROVIDERS` array with the list of detected runtimes.

#### Scenario: Orbstack detected
- **WHEN** `orbstack` binary is found in `$PATH`
- **THEN** `orbstack` SHALL be added to `DOCKER_AVAILABLE_PROVIDERS`

#### Scenario: Colima detected
- **WHEN** `colima` binary is found in `$PATH`
- **THEN** `colima` SHALL be added to `DOCKER_AVAILABLE_PROVIDERS`

#### Scenario: Docker Desktop (macOS) detected
- **WHEN** `DOCKER_HOST_OS` is `macos` and `/Applications/Docker.app` exists or `docker` binary is found
- **THEN** `docker` SHALL be added to `DOCKER_AVAILABLE_PROVIDERS`

#### Scenario: Docker CE (Linux) detected
- **WHEN** `DOCKER_HOST_OS` is `linux` and `docker` binary is found
- **THEN** `docker` SHALL be added to `DOCKER_AVAILABLE_PROVIDERS`

#### Scenario: Lima detected
- **WHEN** `limactl` binary is found in `$PATH`
- **THEN** `lima` SHALL be added to `DOCKER_AVAILABLE_PROVIDERS`

#### Scenario: Podman detected
- **WHEN** `podman` binary is found in `$PATH`
- **THEN** `podman` SHALL be added to `DOCKER_AVAILABLE_PROVIDERS`

### Requirement: DOCKER_HOST auto-resolution
The system SHALL resolve the correct `DOCKER_HOST` socket path based on the active provider, and export it if not already set by the user.

#### Scenario: Orbstack socket path
- **WHEN** active provider is `orbstack`
- **THEN** `DOCKER_HOST` SHALL resolve to `unix://${HOME}/.orbstack/run/docker.sock` (unless already set)

#### Scenario: Colima socket path
- **WHEN** active provider is `colima`
- **THEN** `DOCKER_HOST` SHALL resolve via `colima status --json | jq -r '.docker_socket'` (unless already set)

#### Scenario: Docker Desktop socket path (macOS)
- **WHEN** active provider is `docker` and `DOCKER_HOST_OS` is `macos`
- **THEN** `DOCKER_HOST` SHALL resolve to `unix://${HOME}/.docker/run/docker.sock` (unless already set)

#### Scenario: Docker CE socket path (Linux)
- **WHEN** active provider is `docker` and `DOCKER_HOST_OS` is `linux`
- **THEN** `DOCKER_HOST` SHALL resolve to `unix:///var/run/docker.sock` (unless already set)

#### Scenario: Lima socket path
- **WHEN** active provider is `lima`
- **THEN** `DOCKER_HOST` SHALL resolve via `limactl list --json` (unless already set)

#### Scenario: Podman socket path
- **WHEN** active provider is `podman`
- **THEN** `DOCKER_HOST` SHALL resolve to `unix:///run/user/${UID}/podman/podman.sock` (unless already set)

#### Scenario: User override respected
- **WHEN** `DOCKER_HOST` is already set in the environment
- **THEN** the system SHALL NOT override it

### Requirement: Docker connectivity health check
The system SHALL verify Docker connectivity after load by running `docker info` with a timeout, emitting a warning if unreachable.

#### Scenario: Docker reachable
- **WHEN** `docker info` succeeds within 2 seconds
- **THEN** the module SHALL log a success message and continue silently

#### Scenario: Docker unreachable
- **WHEN** `docker info` fails or times out
- **THEN** the module SHALL emit a warning: "Docker daemon not reachable — check that your container runtime is running"
