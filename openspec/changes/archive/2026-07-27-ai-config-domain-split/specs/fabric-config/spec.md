## ADDED Requirements

### Requirement: Fabric configuration variables
The system SHALL export Fabric-specific configuration variables from `config/fabric.zsh`.

#### Scenario: Fabric paths are exported
- **WHEN** the AI module is loaded
- **THEN** the following variables SHALL be exported:
  - `AI_FABRIC_PATTERNS_PATH`
  - `AI_FABRIC_PATTERNS_SYNC_SOURCE`

### Requirement: Fabric config file is sourceable
The system SHALL source `config/fabric.zsh` from `config/base.zsh` or `config/main.zsh`.

#### Scenario: Fabric config is loaded
- **WHEN** the AI module loads `config/main.zsh`
- **THEN** `config/fabric.zsh` SHALL be sourced and all Fabric variables SHALL be available
