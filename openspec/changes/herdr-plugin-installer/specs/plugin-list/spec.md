## ADDED Requirements

### Requirement: List installed plugins

The system SHALL list all currently installed herdr plugins by running `herdr plugin list`.

#### Scenario: List plugins successfully
- **WHEN** the user calls `herdr::plugin::list`
- **THEN** the system runs `herdr plugin list`
- **AND** displays the output to the user

#### Scenario: List plugins when none are installed
- **WHEN** no plugins are installed
- **THEN** the system displays an appropriate message indicating no plugins are installed

#### Scenario: List plugins when herdr binary is missing
- **WHEN** the herdr binary is not installed
- **THEN** the system displays an error message and does not attempt to list plugins
