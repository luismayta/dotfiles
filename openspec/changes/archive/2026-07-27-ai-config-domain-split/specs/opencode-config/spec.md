## ADDED Requirements

### Requirement: OpenCode configuration variables
The system SHALL export OpenCode-specific configuration variables from `config/opencode.zsh`.

#### Scenario: OpenCode paths are exported
- **WHEN** the AI module is loaded
- **THEN** the following variables SHALL be exported:
  - `AI_OPENCODE_ROOT_PATH`
  - `AI_OPENCODE_BIN_PATH`
  - `AI_OPENCODE_CONFIG_PATH`
  - `AI_OPENCODE_CONFIG_FILE`
  - `AI_OPENCODE_CONFIG_SOURCE_PATH`
  - `AI_OPENCODE_RUNTIME_SOURCE_PATH`
  - `AI_OPENCODE_RUNTIME_CONFIG_PATH`
  - `AI_OPENCODE_CONFIG_FILE_PATH`

### Requirement: OpenCode config file is sourceable
The system SHALL source `config/opencode.zsh` from `config/base.zsh` or `config/main.zsh`.

#### Scenario: OpenCode config is loaded
- **WHEN** the AI module loads `config/main.zsh`
- **THEN** `config/opencode.zsh` SHALL be sourced and all OpenCode variables SHALL be available
