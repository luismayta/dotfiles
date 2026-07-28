## ADDED Requirements

### Requirement: OpenSpec configuration placeholder
The system SHALL have a `config/openspec.zsh` file reserved for future OpenSpec configuration.

#### Scenario: OpenSpec config file exists
- **WHEN** the AI module is loaded
- **THEN** `config/openspec.zsh` SHALL exist (may be empty or contain a comment)

### Requirement: OpenSpec config file is sourceable
The system SHALL source `config/openspec.zsh` from `config/base.zsh` or `config/main.zsh`.

#### Scenario: OpenSpec config is loaded
- **WHEN** the AI module loads `config/main.zsh`
- **THEN** `config/openspec.zsh` SHALL be sourced without errors
