# devops-docker-compose Specification

## Purpose

Integrates the standalone docker-compose CLI into the devops module using the three-layer architecture and the PATH-only pattern, enabling install, upgrade and verification from the shell.

## Requirements

### Requirement: Docker Compose configuration variables
The devops module SHALL expose docker-compose configuration through `DEVOPS_DOCKER_COMPOSE_*` environment variables (`PACKAGE_NAME`, `CONFIG_DIR`).

#### Scenario: Configuration variables are defined
- **WHEN** the devops module loads
- **THEN** `DEVOPS_DOCKER_COMPOSE_PACKAGE_NAME` and `DEVOPS_DOCKER_COMPOSE_CONFIG_DIR` SHALL be defined

### Requirement: Docker Compose registration in DEVOPS_TOOLS
The devops module SHALL register `docker-compose` in the `DEVOPS_TOOLS` array.

#### Scenario: docker-compose present in DEVOPS_TOOLS
- **WHEN** the `DEVOPS_TOOLS` array is inspected
- **THEN** `docker-compose` SHALL be present in the array

### Requirement: PATH-only load pattern
The devops module SHALL load docker-compose using the PATH-only pattern: existence guard with `core::exists docker-compose`, access via PATH, and no `eval` or keybindings.

#### Scenario: docker-compose not installed
- **WHEN** the devops module loads and the docker-compose binary is not found
- **THEN** the load function SHALL return silently without error

#### Scenario: docker-compose installed
- **WHEN** the devops module loads and the docker-compose binary exists
- **THEN** docker-compose SHALL be available via PATH without shell hooks

### Requirement: Docker Compose auto-install
The devops module SHALL install docker-compose on module load when it is missing, via `core::install` with the configured package name.

#### Scenario: auto-install on missing binary
- **WHEN** the devops module loads and docker-compose is not present
- **THEN** the install function SHALL run `core::install` with `DEVOPS_DOCKER_COMPOSE_PACKAGE_NAME`

### Requirement: Public API functions
The devops module SHALL expose public functions `devops::docker-compose::install` and `devops::docker-compose::upgrade`.

#### Scenario: install function is available
- **WHEN** `type devops::docker-compose::install` is invoked
- **THEN** it SHALL resolve to a `function`

#### Scenario: upgrade function is available
- **WHEN** `type devops::docker-compose::upgrade` is invoked
- **THEN** it SHALL resolve to a `function`

### Requirement: Naming and feedback conventions
All functions SHALL use the `devops::docker-compose::` prefix (double colon, never single underscore) and SHALL use `message_info`/`message_success`/`message_error` for user feedback.

#### Scenario: feedback via message helpers
- **WHEN** install or upgrade runs
- **THEN** user feedback SHALL be emitted via `message_*` helpers and never via `echo`

#### Scenario: double-colon prefix on all functions
- **WHEN** the module functions are enumerated
- **THEN** every function SHALL use the `devops::docker-compose::` prefix

### Requirement: Module loads without errors
The devops module SHALL load without errors after docker-compose integration.

#### Scenario: clean module load
- **WHEN** `source zsh/system/core/main.zsh && source zsh/modules/devops/plugin.zsh` is executed
- **THEN** no errors SHALL be raised