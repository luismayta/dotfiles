## ADDED Requirements

### Requirement: Config sync from data directory
The system SHALL synchronize waybar configuration files from the module's `data/` directory to the user's config directory.

#### Scenario: Sync on Linux
- **WHEN** `waybar::sync` is called on Linux
- **THEN** system SHALL execute `rsync -avzh "${ZSH_WAYBAR_DATA_PATH}/" "${WAYBAR_CONFIG_PATH}/"`

#### Scenario: Sync on macOS
- **WHEN** `waybar::sync` is called on macOS
- **THEN** system SHALL execute `rsync -avzh "${ZSH_WAYBAR_DATA_PATH}/" "${WAYBAR_CONFIG_PATH}/"`

### Requirement: Config directory paths
The system SHALL use standard XDG paths for waybar configuration.

#### Scenario: Default config path
- **WHEN** `WAYBAR_CONFIG_PATH` is not set
- **THEN** system SHALL default to `${HOME}/.config/waybar`

#### Scenario: Custom config path
- **WHEN** `WAYBAR_CONFIG_PATH` is set
- **THEN** system SHALL use the custom path

### Requirement: Data directory structure
The system SHALL maintain waybar configuration files in the module's `data/` directory.

#### Scenario: Data directory exists
- **WHEN** waybar module is loaded
- **THEN** `ZSH_WAYBAR_DATA_PATH` SHALL point to `${ZSH_WAYBAR_PATH}/data`
