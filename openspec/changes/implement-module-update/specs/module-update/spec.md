## Purpose

Defines the generic `update` function contract that lets zsh modules bring their tool to the latest version, with the herdr module as its first implementation.

## ADDED Requirements

### Requirement: Generic module update function

Every zsh module under `zsh/modules/` that supports updating its tool SHALL expose an `update` function that reinstalls or updates the tool to its latest version using the module's official installer.

#### Scenario: Module exposes update function

- **WHEN** a zsh module declares update support
- **THEN** the module SHALL provide a public `update` function callable from the shell

### Requirement: herdr update runs official installer

The herdr module SHALL provide `herdr::update` that executes the official installer command `curl -fsSL https://herdr.dev/install.sh | sh`.

#### Scenario: Executing herdr update

- **WHEN** `herdr::update` is invoked
- **THEN** the official installer `curl -fsSL https://herdr.dev/install.sh | sh` SHALL be executed

### Requirement: herdr update success

`herdr::update` MUST return exit code `0` when herdr is available in PATH after running the installer.

#### Scenario: Update succeeds

- **WHEN** the installer completes successfully
- **AND** the `herdr` binary is available in PATH after the update
- **THEN** `herdr::update` MUST return exit code `0`

### Requirement: herdr update failure

`herdr::update` MUST return exit code `1` when the installation fails or the `herdr` binary is not available in PATH after the update.

#### Scenario: Installer fails

- **WHEN** the installer command fails
- **THEN** `herdr::update` MUST return exit code `1`

#### Scenario: Binary missing after update

- **WHEN** the installer completes without error
- **BUT** the `herdr` binary is not available in PATH
- **THEN** `herdr::update` MUST return exit code `1`

### Requirement: Update pattern documentation

The generic `update` function pattern for zsh modules SHALL be documented in `docs/guides/`.

#### Scenario: Guide exists

- **WHEN** a developer needs to add an `update` function to a new zsh module
- **THEN** a guide in `docs/guides/` SHALL describe the pattern, referencing the herdr implementation as the reference example
