## Purpose

Integrates tuicr as a managed AI tool in the `zsh/modules/ai/` module, providing installation, PATH loading, review/pr commands, config synchronization, and post-install guidance following the established three-layer architecture pattern (mirrors `jcode-ai-tool` / `omp-ai-tool`).

## ADDED Requirements

### Requirement: tuicr configuration variables

The system SHALL export environment variables for tuicr configuration in `config/tuicr.zsh`:

- `ZSH_AI_TUICR_BIN_PATH` — tuicr binary directory (`${HOME}/.local/bin`)
- `ZSH_AI_TUICR_CONFIG_PATH` — tuicr config directory (`${HOME}/.config/tuicr`)

All variables in the file SHALL use the `ZSH_AI_TUICR_` prefix, and the file SHALL start with the shebang `#!/usr/bin/env ksh`.

#### Scenario: Config variables are exported

- **WHEN** the AI module config layer loads
- **THEN** `ZSH_AI_TUICR_BIN_PATH` and `ZSH_AI_TUICR_CONFIG_PATH` SHALL be available in the shell environment with the documented values

#### Scenario: Variable prefix is consistent

- **WHEN** `config/tuicr.zsh` is inspected
- **THEN** every exported variable SHALL use the `ZSH_AI_TUICR_` prefix

### Requirement: tuicr PATH loading

The system SHALL provide `ai::internal::tuicr::load` to add the tuicr binary directory to PATH, guarded by tool existence.

#### Scenario: Binary directory added to PATH

- **WHEN** `ai::internal::tuicr::load` is called and `core::exists tuicr` succeeds
- **THEN** `ZSH_AI_TUICR_BIN_PATH` SHALL be prepended to `PATH`

#### Scenario: Missing binary

- **WHEN** `ai::internal::tuicr::load` is called and `core::exists tuicr` fails
- **THEN** the function SHALL return without modifying PATH

#### Scenario: Load invoked at end of file

- **WHEN** `internal/tuicr.zsh` is sourced
- **THEN** `ai::internal::tuicr::load` SHALL be invoked at the end of the file

### Requirement: tuicr installation

The system SHALL provide `ai::internal::tuicr::install` to install tuicr via cargo.

#### Scenario: Successful installation

- **WHEN** `ai::internal::tuicr::install` is called and tuicr is not installed
- **THEN** the system SHALL execute `cargo install tuicr`
- **AND** display a success message via `message_success` upon completion

#### Scenario: Already installed

- **WHEN** `ai::internal::tuicr::install` is called and tuicr is already installed
- **THEN** the system SHALL return 0 without running the installer

#### Scenario: Cargo not available

- **WHEN** `ai::internal::tuicr::install` is called and cargo is not available
- **THEN** the system SHALL display an error message and return 1 without attempting installation

#### Scenario: Installation failure

- **WHEN** `ai::internal::tuicr::install` is called and the cargo command fails
- **THEN** the system SHALL display an error message and return 1

#### Scenario: Progress feedback provided

- **WHEN** installation starts
- **THEN** the system SHALL display an informational message via `message_info`

### Requirement: tuicr public API functions

The system SHALL expose public functions in `pkg/tuicr.zsh` under the `ai::tuicr::` namespace:

- `ai::tuicr::install` — delegates to `ai::internal::tuicr::install`
- `ai::tuicr::review` — executes `tuicr "${@}"`
- `ai::tuicr::pr` — executes `tuicr pr "${@}"`
- `ai::tuicr::config::sync` — copies `data/tuicr/config.toml` to `~/.config/tuicr/`
- `ai::tuicr::post_install` — displays post-installation guidance

The file SHALL start with the shebang `#!/usr/bin/env ksh`.

#### Scenario: Install delegates to internal

- **WHEN** `ai::tuicr::install` is called
- **THEN** the system SHALL invoke `ai::internal::tuicr::install`

#### Scenario: Review runs tuicr

- **WHEN** `ai::tuicr::review` is called with arguments
- **THEN** the system SHALL execute `tuicr` with those arguments

#### Scenario: PR runs tuicr pr

- **WHEN** `ai::tuicr::pr` is called with arguments
- **THEN** the system SHALL execute `tuicr pr` with those arguments

#### Scenario: Config sync copies template

- **WHEN** `ai::tuicr::config::sync` is called
- **THEN** the system SHALL copy `data/tuicr/config.toml` to `~/.config/tuicr/`

#### Scenario: Post-install guidance shown

- **WHEN** `ai::tuicr::post_install` is called
- **THEN** the system SHALL display post-installation guidance to the user

### Requirement: tuicr data layer config template

The system SHALL provide a tuicr configuration template at `data/tuicr/config.toml`.

#### Scenario: Data directory exists

- **WHEN** the AI module data layer is inspected
- **THEN** the `data/tuicr/` directory SHALL exist

#### Scenario: Config is valid TOML

- **WHEN** `data/tuicr/config.toml` is parsed
- **THEN** it SHALL be valid TOML

#### Scenario: Theme configured

- **WHEN** the template is inspected
- **THEN** the theme SHALL be set to `catppuccin-mocha`

#### Scenario: Vim keybindings configured

- **WHEN** the template is inspected
- **THEN** keybindings SHALL follow vim conventions

### Requirement: Registration in module files

The system SHALL register tuicr in three locations:

1. `config/base.zsh` — source `config/tuicr.zsh` and add `tuicr` to the `ZSH_AI_TOOLS` array
2. `internal/main.zsh` — source `internal/tuicr.zsh` and call `ai::internal::tuicr::load`
3. `pkg/main.zsh` — source `pkg/tuicr.zsh`

#### Scenario: Config sourced from base.zsh

- **WHEN** the AI module config layer loads
- **THEN** `config/tuicr.zsh` SHALL be sourced

#### Scenario: tuicr in tool registry

- **WHEN** the AI module config layer loads
- **THEN** `tuicr` SHALL be present in the `ZSH_AI_TOOLS` array

#### Scenario: Internal sourced from main.zsh

- **WHEN** the AI module internal layer loads
- **THEN** `internal/tuicr.zsh` SHALL be sourced
- **AND** `ai::internal::tuicr::load` SHALL be called

#### Scenario: Pkg sourced from main.zsh

- **WHEN** the AI module pkg layer loads
- **THEN** `pkg/tuicr.zsh` SHALL be sourced

#### Scenario: Module loads without errors

- **WHEN** the AI module is sourced
- **THEN** the module SHALL load without errors with tuicr registered