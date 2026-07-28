## ADDED Requirements

### Requirement: Graphify configuration variables
The system SHALL export Graphify-specific configuration variables from `config/graphify.zsh`.

#### Scenario: Graphify paths are exported
- **WHEN** the AI module is loaded
- **THEN** the following variables SHALL be exported:
  - `AI_GRAPHIFY_BIN_PATH`

### Requirement: Graphify config file is sourceable
The system SHALL source `config/graphify.zsh` from `config/base.zsh` or `config/main.zsh`.

#### Scenario: Graphify config is loaded
- **WHEN** the AI module loads `config/main.zsh`
- **THEN** `config/graphify.zsh` SHALL be sourced and all Graphify variables SHALL be available
