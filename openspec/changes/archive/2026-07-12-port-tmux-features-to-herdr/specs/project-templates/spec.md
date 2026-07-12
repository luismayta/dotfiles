## ADDED Requirements

### Requirement: Module ships herdr-plus project templates

The system SHALL ship a collection of herdr-plus project template configurations under `data/plugins/config/cloudmanic.herdr-plus/projects/` that define workspace layouts for common development environments. These are the herdr-plus equivalent of tmuxinator project templates.

#### Scenario: Default template exists
- **WHEN** inspecting `data/plugins/config/cloudmanic.herdr-plus/projects/`
- **THEN** system SHALL have a `default.toml` template as fallback

#### Scenario: Language-specific templates exist
- **WHEN** inspecting `data/plugins/config/cloudmanic.herdr-plus/projects/`
- **THEN** system SHALL have templates for: android, cloud, docker, go, java, nodejs, python, rust

### Requirement: Templates use herdr-plus projects TOML format

Each template SHALL be a herdr-plus projects TOML file defining a workspace with tabs and panes.

#### Scenario: Template structure
- **WHEN** inspecting a template TOML file
- **THEN** it SHALL specify `name`, `description`, `working_dir`, and `group` fields
- **THEN** it SHALL define `[[tabs]]` with pane layout (splits)
- **THEN** it SHALL define `[[tabs.panes]]` with startup commands per pane (editor, shell, etc.)

#### Scenario: Minimal template structure
- **WHEN** a default template is inspected
- **THEN** it SHALL define at minimum: `name`, `description`, one tab with editor pane and shell pane

#### Scenario: Go template has extra app pane
- **WHEN** inspecting `go.toml`
- **THEN** it SHALL define 4 panes: editor, app, opencode, shell (matching the tmuxinator go.yml)

### Requirement: Templates are discoverable

The system SHALL provide a function to list available project templates (used by the project launcher).

#### Scenario: List templates
- **WHEN** `hrd::internal::list_templates` is called
- **THEN** it SHALL return all template names in `data/plugins/config/cloudmanic.herdr-plus/projects/`
- **THEN** it SHALL prefer `fd` if available, fall back to zsh glob
