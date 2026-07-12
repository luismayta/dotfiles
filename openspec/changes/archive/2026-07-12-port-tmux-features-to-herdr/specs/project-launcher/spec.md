## ADDED Requirements

### Requirement: User can launch a project interactively

The system SHALL provide a command `hrd::project` that lets the user select a project template via fzf and create a herdr workspace from it.

#### Scenario: Launch project with template selection
- **WHEN** user runs `hrd::project`
- **THEN** system SHALL list available project templates via fzf with preview
- **THEN** user selects a template
- **THEN** system SHALL derive a project name from the current directory
- **THEN** system SHALL ask for confirmation before creating the workspace

#### Scenario: Launch project by name
- **WHEN** user runs `hrd::project <name>`
- **THEN** system SHALL use `<name>` as the project name
- **THEN** system SHALL prompt for template selection via fzf

#### Scenario: Template preview in fzf
- **WHEN** user browses templates in fzf
- **THEN** system SHALL show a preview of the template contents using `bat` or `cat -n`

#### Scenario: Workspace already exists
- **WHEN** user launches a project and the workspace name already exists
- **THEN** system SHALL ask for confirmation before switching to existing workspace
- **THEN** IF confirmed, system SHALL switch to the existing workspace
