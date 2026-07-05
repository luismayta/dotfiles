## ADDED Requirements

### Requirement: Sync config from data to user config directory
The system SHALL synchronize files from `ZSH_HERDR_DATA_PATH` to `HERDR_CONFIG_PATH` using `rsync`.

#### Scenario: sync triggered with config files present
- **WHEN** `herdr::sync` is called and `ZSH_HERDR_DATA_PATH` contains config files
- **THEN** the system SHALL run `rsync -avzh` from data path to `$HOME/.config/herdr/`
- **THEN** the system SHALL log `message_success` on completion

#### Scenario: sync triggered with empty data directory
- **WHEN** `herdr::sync` is called and `ZSH_HERDR_DATA_PATH` is empty
- **THEN** the system SHALL still run but effectively be a no-op
- **THEN** the system SHALL log `message_info` that no config was found

### Requirement: Public sync command
The system SHALL expose `herdr::sync` as a user-callable function.

#### Scenario: user invokes herdr::sync
- **WHEN** the user runs `herdr::sync`
- **THEN** the system SHALL delegate to `herdr::internal::config::sync`
- **THEN** the system SHALL report results via `message_*` functions
