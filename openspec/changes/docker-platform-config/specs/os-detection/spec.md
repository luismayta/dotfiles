## ADDED Requirements

### Requirement: OS detection at module load
The system SHALL detect the host operating system during module initialization using the `$OSTYPE` variable and export `DOCKER_HOST_OS` with values `macos` or `linux`.

#### Scenario: macOS detection
- **WHEN** `$OSTYPE` starts with `darwin`
- **THEN** `DOCKER_HOST_OS` SHALL be set to `macos`

#### Scenario: Linux detection
- **WHEN** `$OSTYPE` starts with `linux`
- **THEN** `DOCKER_HOST_OS` SHALL be set to `linux`

#### Scenario: Unsupported OS
- **WHEN** `$OSTYPE` does not match `darwin*` or `linux*`
- **THEN** the module SHALL emit a warning and default to Linux-safe settings

### Requirement: OS dispatch via standard file convention
The system SHALL dispatch to OS-specific files using separate `osx.zsh` and `linux.zsh` files per the standard module convention, not a single `os.zsh`.

#### Scenario: config/main.zharwin dispatch
- **WHEN** `$OSTYPE` starts with `darwin`
- **THEN** `config/main.zsh` SHALL source `config/osx.zsh` before the provider dispatch

#### Scenario: config/main.zsh Linux dispatch
- **WHEN** `$OSTYPE` starts with `linux`
- **THEN** `config/main.zsh` SHALL source `config/linux.zsh` before the provider dispatch

#### Scenario: internal/main.zsh OS dispatch
- **WHEN** `$OSTYPE` starts with `darwin` or `linux`
- **THEN** `internal/main.zsh` SHALL source `internal/osx.zsh` or `internal/linux.zsh` respectively

### Requirement: Platform-appropriate default provider
The system SHALL select a default container runtime based on the detected OS, overridable by `DOCKER_CONTAINER_APP_NAME`.

#### Scenario: macOS default provider
- **WHEN** `DOCKER_HOST_OS` is `macos` and `DOCKER_CONTAINER_APP_NAME` is not set
- **THEN** `DOCKER_CONTAINER_APP_NAME` SHALL default to `orbstack`

#### Scenario: Linux default provider
- **WHEN** `DOCKER_HOST_OS` is `linux` and `DOCKER_CONTAINER_APP_NAME` is not set
- **THEN** `DOCKER_CONTAINER_APP_NAME` SHALL default to `docker`

#### Scenario: User override respected
- **WHEN** `DOCKER_CONTAINER_APP_NAME` is explicitly set before module load
- **THEN** the system SHALL use the user-provided value without modification

### Requirement: Platform-specific environment variables
The system SHALL export platform-specific environment variables based on detected OS.

#### Scenario: Linux socket path variable
- **WHEN** `DOCKER_HOST_OS` is `linux`
- **THEN** `DOCKER_SOCKET_PATH` SHALL default to `/var/run/docker.sock`

#### Scenario: macOS socket path variable
- **WHEN** `DOCKER_HOST_OS` is `macos`
- **THEN** `DOCKER_SOCKET_PATH` SHALL be determined by the active provider's config

#### Scenario: Linux docker group variable
- **WHEN** `DOCKER_HOST_OS` is `linux`
- **THEN** `DOCKER_GROUP_NAME` SHALL default to `docker`

#### Scenario: macOS brew prefix variable
- **WHEN** `DOCKER_HOST_OS` is `macos`
- **THEN** `DOCKER_BREW_PREFIX` SHALL resolve via `brew --prefix`
