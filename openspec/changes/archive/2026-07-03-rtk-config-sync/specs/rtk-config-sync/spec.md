## ADDED Requirements

### Requirement: Config path variables defined

The system SHALL define `AI_RTK_CONFIG_PATH` (destination: `~/.config/rtk`) and `AI_RTK_CONFIG_SOURCE_PATH` (source: `${AI_PATH}/data/rtk`) in `config/base.zsh`.

#### Scenario: Variables are exported after config is sourced

- **WHEN** `config/base.zsh` is sourced
- **THEN** `AI_RTK_CONFIG_PATH` SHALL be set to `"${HOME}/.config/rtk"`
- **AND** `AI_RTK_CONFIG_SOURCE_PATH` SHALL be set to `"${AI_PATH}/data/rtk"`

### Requirement: Default RTK config file exists

The system SHALL provide a default `config.toml` at `data/rtk/config.toml` with:
- `[hooks] exclude_commands` array with sensible tool exclusions
- `[tracking] enabled = true`
- `[display]` section with default settings

#### Scenario: Config file is valid TOML

- **WHEN** the file `data/rtk/config.toml` is parsed as TOML
- **THEN** it SHALL parse without errors
- **AND** it SHALL contain a `[hooks]` section with an `exclude_commands` key

### Requirement: Sync function exists

The system SHALL provide `ai::internal::rtk::config::sync` that:
- Creates the destination directory if it doesn't exist
- Runs `rsync -a` from source to destination
- Reports success or failure via `message_success`/`message_error`
- Returns non-zero on failure

#### Scenario: Successful sync

- **WHEN** `ai::internal::rtk::config::sync` is called
- **AND** the source directory exists
- **THEN** `rsync -a "${AI_RTK_CONFIG_SOURCE_PATH}/" "${AI_RTK_CONFIG_PATH}/"` SHALL be executed
- **AND** a success message SHALL be displayed

#### Scenario: Source directory missing

- **WHEN** `ai::internal::rtk::config::sync` is called
- **AND** the source directory does NOT exist
- **THEN** the function SHALL return non-zero
- **AND** an error message SHALL be displayed

#### Scenario: rsync not installed

- **WHEN** `ai::internal::rtk::config::sync` is called
- **AND** `rsync` is not available
- **THEN** the function SHALL return non-zero
- **AND** an error message SHALL be displayed

### Requirement: Sync function is callable from user scope

The system SHALL make the RTK config sync command discoverable alongside other config sync operations.

#### Scenario: Sync can be invoked directly

- **WHEN** a user runs `ai::internal::rtk::config::sync`
- **THEN** the RTK config SHALL be synced from source to destination
