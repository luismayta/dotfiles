## ADDED Requirements

### Requirement: Module installs all AI tools
The system SHALL install the following AI developer tools when `ai::install` is invoked: opencode, fabric, ollama, shimmy, hf, openclaw, tmuxai.

#### Scenario: Install opencode via curl
- **WHEN** `ai::internal::opencode::install` is called and opencode is not installed
- **THEN** curl fetches the installer from `AI_INSTALL_URL_OPENCODE` and executes it via bash

#### Scenario: Install fabric via curl
- **WHEN** `ai::internal::fabric::install` is called and fabric is not installed
- **THEN** curl fetches the installer from `AI_INSTALL_URL_FABRIC` and executes it via bash

#### Scenario: Install ollama via curl
- **WHEN** `ai::internal::ollama::install` is called and ollama is not installed
- **THEN** curl fetches the installer from `AI_INSTALL_URL_OLLAMA` and executes it via sh

#### Scenario: Install shimmy via curl download
- **WHEN** `ai::internal::shimmy::install` is called and shimmy is not installed
- **THEN** the architecture-specific binary is downloaded from `AI_INSTALL_URL_SHIMMY` to `AI_SHIMMY_BIN_PATH` and made executable

#### Scenario: Install hf CLI via curl
- **WHEN** `ai::internal::hf::install` is called and hf is not installed
- **THEN** curl fetches the installer from `AI_INSTALL_URL_HF` and executes it via bash

#### Scenario: Install openclaw via curl
- **WHEN** `ai::internal::openclaw::install` is called and openclaw is not installed
- **THEN** curl fetches the installer from `AI_INSTALL_URL_OPENCLAW` and executes it via bash

#### Scenario: Install tmuxai via curl
- **WHEN** `ai::internal::tmuxai::install` is called and tmuxai is not installed
- **THEN** curl fetches the installer from `AI_INSTALL_URL_TMUXAI` and executes it via bash

#### Scenario: Idempotent — skip if already installed
- **WHEN** any tool's install function is called and the tool binary already exists on PATH
- **THEN** the function returns 0 immediately without downloading

#### Scenario: Batch install all tools
- **WHEN** `ai::install` (public API) is called
- **THEN** every tool in `AI_TOOLS` array is installed via its dedicated install function

#### Scenario: Post-install reports success
- **WHEN** `ai::post_install` is called after installation
- **THEN** a success message with `AI_PACKAGE_NAME` is displayed

### Requirement: Install function detects required dependencies
The SHALL check for `curl` and `bash` before running remote installers.

#### Scenario: curl check fails for tmuxai
- **WHEN** `ai::internal::tmuxai::install` is called and curl is not available
- **THEN** an error message is shown and the function returns 1