## Purpose

Integrates jcode as an AI tool in the zsh/modules/ai/ module, providing installation, configuration synchronization, and PATH loading following the established three-layer architecture pattern.

## ADDED Requirements

### Requirement: jcode configuration variables

The system SHALL export environment variables for jcode configuration in `config/jcode.zsh`:

- `ZSH_AI_JCODE_ROOT_PATH` — jcode root directory (`~/.jcode`)
- `ZSH_AI_JCODE_BIN_PATH` — jcode binary directory (`~/.jcode/bin`)
- `ZSH_AI_JCODE_CONFIG_PATH` — jcode config directory (`~/.config/jcode`)
- `ZSH_AI_JCODE_CONFIG_SOURCE_PATH` — module data source for config sync
- `ZSH_AI_JCODE_INSTALL_URL` — installation URL (`https://jcode.sh/install`)

#### Scenario: Config variables are exported

- **WHEN** the AI module loads
- **THEN** all `ZSH_AI_JCODE_*` variables SHALL be available in the shell environment

### Requirement: jcode PATH loading

The system SHALL provide `ai::internal::jcode::load` to add the jcode binary directory to PATH.

#### Scenario: Binary directory added to PATH

- **WHEN** `ai::internal::jcode::load` is called
- **THEN** `ZSH_AI_JCODE_BIN_PATH` SHALL be prepended to `PATH` if it exists

#### Scenario: Missing binary directory

- **WHEN** `ZSH_AI_JCODE_BIN_PATH` does not exist
- **THEN** `ai::internal::jcode::load` SHALL return silently without modifying PATH

### Requirement: jcode installation

The system SHALL provide `ai::internal::jcode::install` to install jcode via curl.

#### Scenario: Successful installation

- **WHEN** `ai::internal::jcode::install` is called and jcode is not installed
- **THEN** the system SHALL execute `curl -fsSL https://jcode.sh/install | bash`
- **AND** display a success message upon completion

#### Scenario: Already installed

- **WHEN** `ai::internal::jcode::install` is called and jcode is already installed
- **THEN** the system SHALL return 0 without running the installer

#### Scenario: Installation failure

- **WHEN** `ai::internal::jcode::install` is called and the curl command fails
- **THEN** the system SHALL display an error message and return 1

### Requirement: jcode config synchronization

The system SHALL provide `ai::internal::jcode::sync` to synchronize jcode configuration from the module data directory to the user config directory.

#### Scenario: Successful sync

- **WHEN** `ai::internal::jcode::sync` is called
- **THEN** the system SHALL rsync `ZSH_AI_JCODE_CONFIG_SOURCE_PATH` to `ZSH_AI_JCODE_CONFIG_PATH`
- **AND** create the target directory if it does not exist

#### Scenario: rsync not available

- **WHEN** `ai::internal::jcode::sync` is called and rsync is not installed
- **THEN** the system SHALL display an error message and return 1

### Requirement: Public API functions

The system SHALL expose public functions in `pkg/jcode.zsh`:

- `editjcode` — opens jcode config in `$EDITOR`
- `ai::jcode::install` — delegates to `ai::internal::jcode::install`
- `ai::jcode::sync` — delegates to `ai::internal::jcode::sync`

#### Scenario: editjcode opens config

- **WHEN** `editjcode` is called
- **THEN** the system SHALL open `ZSH_AI_JCODE_CONFIG_PATH` in `$EDITOR`

#### Scenario: editjcode without EDITOR

- **WHEN** `editjcode` is called and `$EDITOR` is not set
- **THEN** the system SHALL display a warning message

### Requirement: Registration in module files

The system SHALL register jcode in three locations:

1. `config/base.zsh` — source `config/jcode.zsh` and add `jcode` to `ZSH_AI_TOOLS` array
2. `internal/main.zsh` — source `internal/jcode.zsh` and call `ai::internal::jcode::load`
3. `pkg/main.zsh` — source `pkg/jcode.zsh`

#### Scenario: Config sourced from base.zsh

- **WHEN** the AI module config layer loads
- **THEN** `config/jcode.zsh` SHALL be sourced

#### Scenario: jcode in tool registry

- **WHEN** the AI module config layer loads
- **THEN** `jcode` SHALL be present in the `ZSH_AI_TOOLS` array

#### Scenario: Internal sourced from main.zsh

- **WHEN** the AI module internal layer loads
- **THEN** `internal/jcode.zsh` SHALL be sourced
- **AND** `ai::internal::jcode::load` SHALL be called

#### Scenario: Pkg sourced from main.zsh

- **WHEN** the AI module pkg layer loads
- **THEN** `pkg/jcode.zsh` SHALL be sourced

### Requirement: No plugin.zsh modification required

The system SHALL NOT require modifications to `plugin.zsh` — it already chains config/main.zsh → internal/main.zsh → pkg/main.zsh.

#### Scenario: Plugin loads jcode automatically

- **WHEN** `plugin.zsh` is sourced
- **THEN** jcode functions SHALL be available without any changes to `plugin.zsh`
