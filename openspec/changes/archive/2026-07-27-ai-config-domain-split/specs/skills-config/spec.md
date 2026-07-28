## ADDED Requirements

### Requirement: Skills configuration variables
The system SHALL export Skills-specific configuration variables from `config/skills.zsh`.

#### Scenario: Skills paths and repos are exported
- **WHEN** the AI module is loaded
- **THEN** the following variables SHALL be exported:
  - `AI_SKILLS_BIN_PATH`
  - `AI_SKILLS_CONFIG_PATH`
  - `AI_SKILLS_DATA_PATH`
  - `AI_SKILLS_REPOS`
  - `AI_SKILLS_VERCEL`
  - `AI_SKILLS_CODIP`

### Requirement: Skills config file is sourceable
The system SHALL source `config/skills.zsh` from `config/base.zsh` or `config/main.zsh`.

#### Scenario: Skills config is loaded
- **WHEN** the AI module loads `config/main.zsh`
- **THEN** `config/skills.zsh` SHALL be sourced and all Skills variables SHALL be available
