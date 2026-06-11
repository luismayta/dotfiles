## ADDED Requirements

### Requirement: Module lists available ollama models
The system SHALL list all locally available ollama models.

#### Scenario: List models successfully
- **WHEN** `ai::ollama::models::list` is called and ollama is installed
- **THEN** the output of `ollama list` is displayed

#### Scenario: List fails without ollama
- **WHEN** `ai::ollama::models::list` is called and ollama is not installed
- **THEN** an error message is displayed and the function returns 1

### Requirement: Module pulls specific ollama model
The system SHALL pull a named ollama model from the registry.

#### Scenario: Pull model by name
- **WHEN** `ai::ollama::models::pull <model>` is called and ollama is installed
- **THEN** `ollama pull <model>` is executed

#### Scenario: Pull fails without model argument
- **WHEN** `ai::ollama::models::pull` is called without a model name
- **THEN** a usage error message is displayed and the function returns 1

#### Scenario: Pull fails without ollama
- **WHEN** `ai::ollama::models::pull <model>` is called and ollama is not installed
- **THEN** an error message is displayed and the function returns 1

### Requirement: Module installs default ollama models
The system SHALL install all models listed in `AI_OLLAMA_MODELS` environment variable.

#### Scenario: Install all default models
- **WHEN** `ai::ollama::models::install` is called and ollama is installed
- **THEN** each model in `AI_OLLAMA_MODELS` is pulled sequentially via `ollama pull`

#### Scenario: Install fails without ollama
- **WHEN** `ai::ollama::models::install` is called and ollama is not installed
- **THEN** an error message is displayed and the function returns 1