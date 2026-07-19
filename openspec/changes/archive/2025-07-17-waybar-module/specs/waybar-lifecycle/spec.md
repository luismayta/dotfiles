## ADDED Requirements

### Requirement: Public install function
The system SHALL expose `waybar::install` as a public function.

#### Scenario: Call install function
- **WHEN** user calls `waybar::install`
- **THEN** system SHALL execute waybar installation logic

### Requirement: Public sync function
The system SHALL expose `waybar::sync` as a public function.

#### Scenario: Call sync function
- **WHEN** user calls `waybar::sync`
- **THEN** system SHALL sync waybar configuration

### Requirement: Public setup orchestrator
The system SHALL expose `waybar::setup` as an orchestrator function.

#### Scenario: Setup with waybar not installed
- **WHEN** user calls `waybar::setup`
- **AND** waybar is not installed
- **THEN** system SHALL install waybar
- **AND** system SHALL sync configuration
- **AND** system SHALL display success message

#### Scenario: Setup with waybar already installed
- **WHEN** user calls `waybar::setup`
- **AND** waybar is already installed
- **THEN** system SHALL sync configuration
- **AND** system SHALL display success message

### Requirement: Public health check function
The system SHALL expose `waybar::check` as a health check function.

#### Scenario: Check waybar installation status
- **WHEN** user calls `waybar::check`
- **AND** waybar is installed
- **THEN** system SHALL display success message with waybar status

#### Scenario: Check waybar not installed
- **WHEN** user calls `waybar::check`
- **AND** waybar is not installed
- **THEN** system SHALL display error message with waybar status

### Requirement: Module guard against double-loading
The system SHALL prevent double-loading of the waybar module.

#### Scenario: Module loaded twice
- **WHEN** waybar module is sourced a second time
- **THEN** system SHALL skip loading
- **AND** system SHALL not display loading message again
