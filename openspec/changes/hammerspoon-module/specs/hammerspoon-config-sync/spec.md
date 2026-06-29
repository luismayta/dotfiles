## ADDED Requirements

### Requirement: Sync config from data directory
The system SHALL sync the Hammerspoon configuration from the module's `data/` directory to `~/.hammerspoon/` using rsync.

#### Scenario: First-time sync
- **WHEN** `hammerspoon::sync` is called and `~/.hammerspoon/` does not exist
- **THEN** the system SHALL create `~/.hammerspoon/` and copy all files from `data/`

#### Scenario: Incremental sync
- **WHEN** `hammerspoon::sync` is called and `~/.hammerspoon/` already exists
- **THEN** the system SHALL only copy changed files using rsync

### Requirement: Preserve user customizations
The system SHALL NOT overwrite `~/.hammerspoon/custom.lua` during sync, as this file contains user-specific keybindings.

#### Scenario: custom.lua exists at destination
- **WHEN** `hammerspoon::sync` runs and `custom.lua` exists in `~/.hammerspoon/`
- **THEN** the system SHALL preserve the existing `custom.lua` file
