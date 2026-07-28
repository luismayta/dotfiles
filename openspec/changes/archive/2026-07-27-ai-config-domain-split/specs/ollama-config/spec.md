## ADDED Requirements

### Requirement: Ollama configuration variables
The system SHALL export Ollama-specific configuration variables from `config/ollama.zsh`.

#### Scenario: Ollama paths are exported
- **WHEN** the AI module is loaded
- **THEN** the following variables SHALL be exported:
  - `AI_OLLAMA_MODELS_PATH`

### Requirement: Ollama config file is sourceable
The system SHALL source `config/ollama.zsh` from `config/base.zsh` or `config/main.zsh`.

#### Scenario: Ollama config is loaded
- **WHEN** the AI module loads `config/main.zsh`
- **THEN** `config/ollama.zsh` SHALL be sourced and all Ollama variables SHALL be available
