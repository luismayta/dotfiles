## MODIFIED Requirements

### Requirement: Provide public wrapper functions
The system SHALL expose public functions for graphify operations.

#### Scenario: Install function available
- **WHEN** user sources the AI module
- **THEN** `ai::graphify::install` function SHALL be available

#### Scenario: Upgrade function available
- **WHEN** user sources the AI module
- **THEN** `ai::graphify::upgrade` function SHALL be available (alias for install with force)

#### Scenario: Setup function available
- **WHEN** user sources the AI module
- **THEN** `ai::graphify::setup` function SHALL be available for project-scoped registration
