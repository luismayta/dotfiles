## ADDED Requirements

### Requirement: Module provides editopencode helper
The system SHALL provide an `editopencode` shell function to edit the opencode config file.

#### Scenario: Edit opencode config with EDITOR
- **WHEN** `editopencode` is called and `EDITOR` environment variable is set
- **THEN** `$EDITOR` opens `AI_OPENCODE_CONFIG_FILE_PATH`

#### Scenario: Edit fails without EDITOR
- **WHEN** `editopencode` is called and `EDITOR` is not set
- **THEN** a warning message is displayed

### Requirement: Module provides tool install helpers
The system SHALL expose public install functions for each AI tool.

#### Scenario: All helpers are callable
- **WHEN** any of `ai::opencode::install`, `ai::fabric::install`, `ai::ollama::install`, `ai::shimmy::install`, `ai::hf::install`, `ai::openclaw::install`, `ai::tmuxai::install` is called
- **THEN** the corresponding internal install function is invoked

### Requirement: Module loads PATH extensions
The system SHALL add tool binary directories to PATH when they exist.

#### Scenario: opencode bin dir on PATH
- **WHEN** `ai::internal::opencode::load` is called and `AI_OPENCODE_BIN_PATH` exists
- **THEN** that path is prepended to `PATH`

#### Scenario: shimmy bin dir on PATH
- **WHEN** `ai::internal::shimmy::load` is called and `AI_SHIMMY_BIN_PATH` exists
- **THEN** that path is prepended to `PATH`

#### Scenario: openclaw bin dir on PATH
- **WHEN** `ai::internal::openclaw::load` is called and `AI_OPENCLAW_BIN_PATH` exists
- **THEN** that path is prepended to `PATH`