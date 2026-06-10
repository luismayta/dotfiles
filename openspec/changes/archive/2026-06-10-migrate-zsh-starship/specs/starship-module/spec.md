## ADDED Requirements

### Requirement: Starship prompt initialization
The system SHALL initialize the starship prompt with proper configuration.

#### Scenario: Initialize starship prompt
- **WHEN** the starship module loads
- **THEN** the starship prompt SHALL be initialized with the module's configuration

### Requirement: Starship configuration management
The system SHALL manage the starship.toml configuration file.

#### Scenario: Configure starship from module config
- **WHEN** the starship module loads
- **THEN** the module's starship.toml SHALL be used as the prompt configuration

#### Scenario: Custom configuration path
- **WHEN** `STARSHIP_CONFIG` env var is set
- **THEN** the system SHALL respect the user's custom starship config path