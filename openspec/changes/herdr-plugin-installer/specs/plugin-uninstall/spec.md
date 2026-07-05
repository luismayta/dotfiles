## ADDED Requirements

### Requirement: Uninstall a plugin

The system SHALL remove an installed herdr plugin using `herdr plugin uninstall <shorthand>`.

#### Scenario: Uninstall a plugin successfully
- **WHEN** the user calls `herdr::plugin::uninstall "0x5c0f/herdr-insight"`
- **THEN** the system runs `herdr plugin uninstall 0x5c0f/herdr-insight`
- **AND** displays a success message

#### Scenario: Uninstall a plugin that is not installed
- **WHEN** the user calls `herdr::plugin::uninstall "nonexistent/plugin"`
- **THEN** the system displays a warning that the plugin is not installed

#### Scenario: Uninstall when herdr binary is missing
- **WHEN** the herdr binary is not installed
- **THEN** the system displays an error message and does not attempt uninstallation
