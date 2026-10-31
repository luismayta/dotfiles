# Spec Delta

## Purpose

Defines the lifecycle behavior of the rclone tool inside the devops zsh module: configuration variables, PATH-only load guard, native package-manager install and upgrade, auto-install when missing, public API wrappers, and post-install guidance.

## ADDED Requirements

### Requirement: rclone configuration variables
The module SHALL expose rclone configuration via `DEVOPS_RCLONE_*` environment variables, including `DEVOPS_RCLONE_PACKAGE_NAME` (set to `rclone`) and `DEVOPS_RCLONE_CONFIG_DIR`, defined in `config/rclone.zsh` with the `#!/usr/bin/env ksh` shebang.

#### Scenario: Config layer loads variables
- **WHEN** the devops module config layer is sourced
- **THEN** `DEVOPS_RCLONE_PACKAGE_NAME` and `DEVOPS_RCLONE_CONFIG_DIR` are defined and exported

### Requirement: rclone is a registered module tool
`rclone` SHALL be present in the `DEVOPS_TOOLS` array in `config/base.zsh` and its config, internal, and pkg files SHALL be sourced from `config/main.zsh`, `internal/main.zsh`, and `pkg/main.zsh` respectively.

#### Scenario: Tool registered in DEVOPS_TOOLS
- **WHEN** `config/base.zsh` is loaded
- **THEN** the `DEVOPS_TOOLS` array contains the entry `rclone`

#### Scenario: Three-layer wiring
- **WHEN** the devops module is loaded
- **THEN** `config/rclone.zsh`, `internal/rclone.zsh`, and `pkg/rclone.zsh` are all sourced without errors

### Requirement: PATH-only load guard
`devops::rclone::internal::load` SHALL return early when `rclone` is not available on PATH, using a `core::exists rclone` guard, and SHALL perform no shell-hook or eval initialization when it is available.

#### Scenario: rclone missing from PATH
- **WHEN** `devops::rclone::internal::load` runs and `rclone` is not installed
- **THEN** the function returns without side effects

#### Scenario: rclone available on PATH
- **WHEN** `devops::rclone::internal::load` runs and `rclone` is installed
- **THEN** the module loads without errors

### Requirement: rclone installation via native package manager
`devops::rclone::internal::install` SHALL install rclone using `core::install "${DEVOPS_RCLONE_PACKAGE_NAME}"` without hardcoded install commands, SHALL report progress with `message_info` and `message_success`, and SHALL skip installation when rclone is already present.

#### Scenario: Install when missing
- **WHEN** `devops::rclone::internal::install` runs and `rclone` is not installed
- **THEN** it calls `core::install` with the package name variable and emits info and success messages

#### Scenario: Install when already present
- **WHEN** `devops::rclone::internal::install` runs and `rclone` is already installed
- **THEN** it reports that rclone is already installed and does not reinstall

### Requirement: rclone upgrade
`devops::rclone::internal::upgrade` SHALL upgrade an existing rclone installation through the native package manager path, delegating to install when rclone is missing.

#### Scenario: Upgrade with rclone installed
- **WHEN** `devops::rclone::internal::upgrade` runs and `rclone` is installed
- **THEN** it performs the upgrade and emits info and success messages

#### Scenario: Upgrade with rclone missing
- **WHEN** `devops::rclone::internal::upgrade` runs and `rclone` is not installed
- **THEN** it falls back to installation

### Requirement: Auto-install on module load
`devops::rclone::internal::main::factory` SHALL ensure rclone is present on module load, triggering installation when the binary is missing.

#### Scenario: rclone missing triggers install
- **WHEN** the devops module loads and `rclone` is not installed
- **THEN** the factory triggers `devops::rclone::internal::install`

#### Scenario: rclone present skips install
- **WHEN** the devops module loads and `rclone` is already installed
- **THEN** no installation is performed

### Requirement: Public API wrappers
`pkg/rclone.zsh` SHALL expose public functions `devops::rclone::install`, `devops::rclone::upgrade`, and `devops::rclone::post_install`, each delegating to the corresponding internal function or behavior.

#### Scenario: Public functions are defined
- **WHEN** the pkg layer is loaded
- **THEN** `devops::rclone::install`, `devops::rclone::upgrade`, and `devops::rclone::post_install` are all recognized as functions

#### Scenario: install delegates to internal
- **WHEN** a user runs `devops::rclone::install`
- **THEN** the internal install logic runs

### Requirement: Post-install guidance
`devops::rclone::post_install` SHALL print rclone usage guidance via `message_info`, including `rclone config` and `rclone listremotes`.

#### Scenario: Guidance shown after install
- **WHEN** a user runs `devops::rclone::post_install`
- **THEN** guidance referencing `rclone config` and `rclone listremotes` is displayed

### Requirement: Output and naming conventions
All rclone module output SHALL use `message_info`, `message_success`, or `message_error` (never bare `echo`), and all variables and functions SHALL use the `DEVOPS_RCLONE_*` and `devops::rclone::*` double-colon conventions — never single-underscore prefixes like `devops_rclone_`.

#### Scenario: No bare echo usage
- **WHEN** the rclone module files are inspected
- **THEN** no `echo` calls are used for user-facing output

#### Scenario: Convention prefixes
- **WHEN** the rclone module files are inspected
- **THEN** variables use `DEVOPS_RCLONE_` and functions use `devops::rclone::` or `devops::rclone::internal::` prefixes