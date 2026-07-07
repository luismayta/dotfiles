## ADDED Requirements

### Requirement: Skill path discovery
The system SHALL provide a function to discover the hunk AI agent skill file path.

#### Scenario: Get skill path
- **WHEN** user calls `ai::hunk::skill::path`
- **THEN** it SHALL execute `hunk skill path` and return the absolute path to the skill file

#### Scenario: Skill path when hunk is not installed
- **WHEN** user calls `ai::hunk::skill::path` AND hunk is not installed
- **THEN** it SHALL print an error message AND return 1

### Requirement: Command documentation with skill integration
The hadx-review command SHALL document how to load the hunk skill for AI agent review sessions.

#### Scenario: hadx-review documents skill usage
- **WHEN** user reads the hadx-review command help
- **THEN** it SHALL include instructions on using `ai::hunk::skill::path` to load the hunk skill into the agent

#### Scenario: hadx-review error handling for missing hunk
- **WHEN** user runs hadx-review steps AND hunk is not installed
- **THEN** the command SHALL detect the missing dependency AND guide the user to install it
