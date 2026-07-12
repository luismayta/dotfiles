## ADDED Requirements

### Requirement: User can switch workspace interactively

The system SHALL provide a command `hrd` that lets the user fuzzy-search and switch to a herdr workspace using fzf.

#### Scenario: Switch workspace inside herdr
- **WHEN** user runs `hrd` inside a herdr session
- **THEN** system SHALL list all herdr workspaces via fzf
- **THEN** system SHALL switch to the selected workspace

#### Scenario: Switch workspace outside herdr
- **WHEN** user runs `hrd` outside a herdr session
- **THEN** system SHALL list all herdr workspaces via fzf
- **THEN** system SHALL attach to the selected workspace

#### Scenario: Switch to workspace by name
- **WHEN** user runs `hrd <name>`
- **THEN** system SHALL search for a workspace named `<name>`
- **THEN** IF found, system SHALL switch to it
- **THEN** IF not found, system SHALL create and switch to a new workspace named `<name>`

#### Scenario: No herdr workspaces exist
- **WHEN** user runs `hrd` and no workspaces exist
- **THEN** system SHALL display a message indicating no workspaces
- **THEN** system SHALL prompt to create a new workspace

### Requirement: User can kill workspace interactively

The system SHALL provide a command `hrdk` that lets the user fuzzy-search and kill a herdr workspace using fzf.

#### Scenario: Kill workspace
- **WHEN** user runs `hrdk`
- **THEN** system SHALL list all herdr workspaces via fzf
- **THEN** system SHALL kill the selected workspace after confirmation

#### Scenario: Kill workspace by name
- **WHEN** user runs `hrdk <name>`
- **THEN** system SHALL kill the workspace named `<name>` without fzf prompt
