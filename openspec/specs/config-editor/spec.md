## ADDED Requirements

### Requirement: User can edit herdr config quickly

The system SHALL provide a command `edit-herdr-config` that opens the herdr configuration file in `$EDITOR`.

#### Scenario: Edit main config
- **WHEN** user runs `edit-herdr-config`
- **THEN** system SHALL open `$HERDR_CONFIG_PATH/config.toml` in `$EDITOR`
- **THEN** IF `$EDITOR` is not set, system SHALL fall back to `vim`

#### Scenario: Edit config file does not exist
- **WHEN** user runs `edit-herdr-config` and the config file does not exist
- **THEN** system SHALL create the file with default content
- **THEN** system SHALL open it in `$EDITOR`

### Requirement: User can edit herdr plugins config quickly

The system SHALL provide a command `edit-herdr-plugins` that opens the herdr plugins configuration.

#### Scenario: Edit plugins config
- **WHEN** user runs `edit-herdr-plugins`
- **THEN** system SHALL open the plugins config directory in `$EDITOR`
- **THEN** IF directory does not exist, system SHALL create it first
