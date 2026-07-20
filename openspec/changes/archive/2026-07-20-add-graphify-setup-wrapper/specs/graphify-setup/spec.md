## ADDED Requirements

### Requirement: Project-scoped graphify setup function
The system SHALL provide `ai::graphify::setup` as a public function that registers graphify skills for the current project.

#### Scenario: Setup function available
- **WHEN** user sources the AI module
- **THEN** `ai::graphify::setup` function SHALL be available in the shell

#### Scenario: Successful project setup
- **WHEN** user runs `ai::graphify::setup` and graphify is installed
- **THEN** system SHALL execute `graphify install --platform opencode --project` and report success

#### Scenario: Graphify not installed
- **WHEN** user runs `ai::graphify::setup` and graphify binary is not found
- **THEN** system SHALL display error message indicating graphify is not installed

### Requirement: Idempotent project setup
The system SHALL allow repeated calls to `ai::graphify::setup` without side effects.

#### Scenario: Repeated setup calls
- **WHEN** user runs `ai::graphify::setup` multiple times
- **THEN** system SHALL execute the command each time and report success (graphify handles deduplication internally)
