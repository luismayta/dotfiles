## Purpose

Integrates OmniRoute as an AI tool in the zsh/modules/ai/ module, providing installation, upgrade, configuration synchronization, and PATH loading following the established three-layer architecture pattern.

## ADDED Requirements

### Requirement: OmniRoute configuration variables

The system SHALL export environment variables for OmniRoute configuration in `config/omniroute.zsh`:

- `ZSH_AI_OMNIROUTE_PACKAGE_NAME` — tool name for messages (`omniroute`)
- `ZSH_AI_OMNIROUTE_INSTALL_CMD` — npm install command (`npm install -g`)
- `ZSH_AI_OMNIROUTE_CONFIG_DIR` — OmniRoute config directory (`~/.omniroute`)
- `ZSH_AI_OMNIROUTE_DATA_PATH` — module data source for config sync

#### Scenario: Config variables are exported

- **WHEN** the AI module loads
- **THEN** all `ZSH_AI_OMNIROUTE_*` variables SHALL be available in the shell environment

### Requirement: OmniRoute PATH loading

The system SHALL provide `ai::internal::omniroute::load` that returns silently when the `omniroute` binary is not present, since the npm global bin directory is already on PATH.

#### Scenario: Binary available

- **WHEN** `ai::internal::omniroute::load` is called and `omniroute` exists on PATH
- **THEN** the function SHALL return without error and without modifying PATH

#### Scenario: Binary missing

- **WHEN** `ai::internal::omniroute::load` is called and `omniroute` is not installed
- **THEN** the function SHALL return silently without error

### Requirement: OmniRoute installation

The system SHALL provide `ai::internal::omniroute::install` to install OmniRoute globally via npm.

#### Scenario: Successful installation

- **WHEN** `ai::internal::omniroute::install` is called and `omniroute` is not installed
- **THEN** the system SHALL execute `bun add -g omniroute`
- **AND** display a success message upon completion

#### Scenario: Already installed

- **WHEN** `ai::internal::omniroute::install` is called and `omniroute` is already installed
- **THEN** the system SHALL return 0 without running the installer

#### Scenario: Installation failure

- **WHEN** `ai::internal::omniroute::install` is called and the bun command fails
- **THEN** the system SHALL display an error message and return 1

### Requirement: OmniRoute upgrade

The system SHALL provide `ai::internal::omniroute::upgrade` to update OmniRoute to the latest version.

#### Scenario: Successful upgrade

- **WHEN** `ai::internal::omniroute::upgrade` is called and `omniroute` is installed
- **THEN** the system SHALL reinstall OmniRoute via bun (`bun add -g omniroute@latest --force`)
- **AND** display a success message upon completion

#### Scenario: Upgrade when not installed

- **WHEN** `ai::internal::omniroute::upgrade` is called and `omniroute` is not installed
- **THEN** the system SHALL install OmniRoute instead of upgrading

### Requirement: OmniRoute config synchronization

The system SHALL provide `ai::internal::omniroute::sync` to synchronize OmniRoute configuration from the module data directory to the user config directory when module data exists.

#### Scenario: Successful sync

- **WHEN** `ai::internal::omniroute::sync` is called and `ZSH_AI_OMNIROUTE_DATA_PATH` contains files
- **THEN** the system SHALL rsync `ZSH_AI_OMNIROUTE_DATA_PATH` to `ZSH_AI_OMNIROUTE_CONFIG_DIR`
- **AND** create the target directory if it does not exist

#### Scenario: No module data

- **WHEN** `ai::internal::omniroute::sync` is called and `ZSH_AI_OMNIROUTE_DATA_PATH` does not exist
- **THEN** the system SHALL return silently without error

### Requirement: Public API functions

The system SHALL expose public functions in `pkg/omniroute.zsh`:

- `ai::omniroute::install` — delegates to `ai::internal::omniroute::install`
- `ai::omniroute::upgrade` — delegates to `ai::internal::omniroute::upgrade`
- `ai::omniroute::sync` — delegates to `ai::internal::omniroute::sync`

#### Scenario: Public wrappers delegate

- **WHEN** `ai::omniroute::install`, `ai::omniroute::upgrade`, or `ai::omniroute::sync` is called
- **THEN** the system SHALL invoke the corresponding `ai::internal::omniroute::*` function

### Requirement: Registration in module files

The system SHALL register OmniRoute in four locations:

1. `config/base.zsh` — source `config/omniroute.zsh` and add `omniroute` to the `ZSH_AI_TOOLS` array
2. `internal/main.zsh` — source `internal/omniroute.zsh` and call `ai::internal::omniroute::load`
3. `pkg/main.zsh` — source `pkg/omniroute.zsh`
4. `pkg/base.zsh` — add `ai::omniroute::sync` to the `ai::sync` aggregator

#### Scenario: Config sourced from base.zsh

- **WHEN** the AI module config layer loads
- **THEN** `config/omniroute.zsh` SHALL be sourced

#### Scenario: OmniRoute in tool registry

- **WHEN** the AI module config layer loads
- **THEN** `omniroute` SHALL be present in the `ZSH_AI_TOOLS` array

#### Scenario: Internal sourced from main.zsh

- **WHEN** the AI module internal layer loads
- **THEN** `internal/omniroute.zsh` SHALL be sourced
- **AND** `ai::internal::omniroute::load` SHALL be called

#### Scenario: Pkg sourced from main.zsh

- **WHEN** the AI module pkg layer loads
- **THEN** `pkg/omniroute.zsh` SHALL be sourced

#### Scenario: Sync aggregated

- **WHEN** `ai::sync` is called
- **THEN** `ai::omniroute::sync` SHALL be executed as part of the aggregation

### Requirement: No plugin.zsh modification required

The system SHALL NOT require modifications to `plugin.zsh` — it already chains config/main.zsh → internal/main.zsh → pkg/main.zsh.

#### Scenario: Plugin loads OmniRoute automatically

- **WHEN** `plugin.zsh` is sourced
- **THEN** OmniRoute functions SHALL be available without any changes to `plugin.zsh`