## ADDED Requirements

### Requirement: Shared tool configuration variables
The system SHALL export shared tool configuration variables from `config/tools.zsh`.

#### Scenario: Shared tool paths are exported
- **WHEN** the AI module is loaded
- **THEN** the following variables SHALL be exported:
  - `AI_SHIMMY_BIN_PATH`
  - `AI_OPENCLAW_BIN_PATH`
  - `AI_CODEGRAPH_BIN_PATH`
  - `AI_RTK_BIN_PATH`
  - `AI_RTK_CONFIG_PATH`
  - `AI_RTK_CONFIG_SOURCE_PATH`
  - `AI_HUNK_BIN_PATH`
  - `AI_HUNK_CONFIG_PATH`
  - `AI_PI_BIN_PATH`
  - `AI_PI_CONFIG_PATH`
  - `AI_PI_CONFIG_SOURCE_PATH`

### Requirement: Tools config file is sourceable
The system SHALL source `config/tools.zsh` from `config/base.zsh` or `config/main.zsh`.

#### Scenario: Tools config is loaded
- **WHEN** the AI module loads `config/main.zsh`
- **THEN** `config/tools.zsh` SHALL be sourced and all shared tool variables SHALL be available
