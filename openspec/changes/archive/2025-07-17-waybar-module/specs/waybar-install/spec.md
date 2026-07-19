## ADDED Requirements

### Requirement: Waybar installation via package manager
The system SHALL install waybar using the platform-appropriate package manager (paru on Arch Linux, brew on macOS).

#### Scenario: Install on Linux
- **WHEN** waybar module is loaded on Linux
- **AND** waybar is not installed
- **THEN** system SHALL execute `core::install waybar`

#### Scenario: Install on macOS
- **WHEN** waybar module is loaded on macOS
- **AND** waybar is not installed
- **THEN** system SHALL execute `core::install waybar`

#### Scenario: Waybar already installed
- **WHEN** waybar module is loaded
- **AND** waybar is already installed
- **THEN** system SHALL skip installation
- **AND** system SHALL display success message

### Requirement: Installation error handling
The system SHALL handle installation failures gracefully.

#### Scenario: Installation fails
- **WHEN** waybar installation fails
- **THEN** system SHALL display error message
- **AND** system SHALL return non-zero exit code
