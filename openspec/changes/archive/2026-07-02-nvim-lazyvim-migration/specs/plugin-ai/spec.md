## ADDED Requirements

### Requirement: Configure codeium.nvim
The system SHALL configure codeium.nvim for AI-powered code completion.

#### Scenario: Codeium suggests completions
- **WHEN** user types code in insert mode
- **THEN** codeium SHALL suggest AI-powered completions asynchronously

### Requirement: Configure codesnap.nvim
The system SHALL configure codesnap.nvim for creating beautiful code snippet images.

#### Scenario: Code snapshot is generated
- **WHEN** user invokes the codesnap command
- **THEN** a PNG image of the selected code SHALL be generated with a styled background
