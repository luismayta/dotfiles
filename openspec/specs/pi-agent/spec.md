# pi-agent Specification

## Purpose
TBD - created by archiving change integrate-pi-agent. Update Purpose after archive.
## Requirements
### Requirement: Pi agent installation
The system SHALL support installing the Pi AI agent framework via the module's batch install system.

#### Scenario: Batch install includes pi
- **WHEN** user runs `ai::install` or `ai::packages::install`
- **THEN** the install process SHALL include `pi` in the iteration over `AI_TOOLS`
- **AND** `ai::internal::pi::install` SHALL be invoked if pi is not already installed

#### Scenario: Standalone pi install
- **WHEN** user runs `ai::pi::install`
- **THEN** the system SHALL run `curl -fsSL https://pi.dev/install.sh | sh`
- **AND** exit early with success if `pi` binary already exists
- **AND** report error if curl or install script fails

### Requirement: Pi agent PATH loading
The system SHALL automatically add Pi to the PATH when the AI module loads.

#### Scenario: Pi binary exists
- **WHEN** `~/.local/bin/pi` exists at shell startup
- **THEN** the system SHALL prepend `~/.local/bin` to `PATH`

#### Scenario: Pi binary not found
- **WHEN** `~/.local/bin/pi` does not exist
- **THEN** the system SHALL NOT modify `PATH` for pi

### Requirement: Pi agent configuration variables
The system SHALL define environment variables for Pi integration.

#### Scenario: Variables are exported
- **WHEN** the AI module config is sourced
- **THEN** `AI_PI_BIN_PATH` SHALL be set to `~/.local/bin`
- **AND** `AI_INSTALL_URL_PI` SHALL be set to `https://pi.dev/install.sh`
- **AND** `AI_PI_CONFIG_PATH` SHALL be set to `~/.pi/agent`
- **AND** `AI_PI_CONFIG_SOURCE_PATH` SHALL point to `$AI_PATH/data/pi`
- **AND** `pi` SHALL be included in `AI_TOOLS` array

### Requirement: Pi configuration sync
The system SHALL support syncing Pi configuration from the dotfiles repo to `~/.pi/agent/`.

#### Scenario: Config sync with source files
- **WHEN** user runs `ai::sync`
- **THEN** the system SHALL rsync contents of `$AI_PI_CONFIG_SOURCE_PATH` to `$AI_PI_CONFIG_PATH`
- **AND** report success when sync completes
- **AND** report warning if source path does not exist

#### Scenario: Standalone pi config sync
- **WHEN** user runs `ai::pi::config::sync`
- **THEN** the system SHALL sync Pi configuration files

### Requirement: OpenCode Zen provider configuration
The system SHALL provide a default `models.json` for Pi configured with OpenCode Zen as provider.

#### Scenario: OpenCode Zen provider defined
- **WHEN** Pi loads `models.json`
- **THEN** a provider named `opencode-zen` SHALL be configured with:
  - **AND** `baseUrl` pointing to OpenCode Zen API
  - **AND** `api` set to `openai-completions`
  - **AND** `apiKey` referencing `{env:OPENCODE_ZEN_API_KEY}`
  - **AND** at least model `opencode/big-pickle` listed

### Requirement: Pi default settings
The system SHALL provide a default `settings.json` for Pi.

#### Scenario: Default settings defined
- **WHEN** Pi loads `settings.json`
- **THEN** `defaultProvider` SHALL be set to `opencode-zen`
- **AND** `defaultModel` SHALL be set to `opencode/big-pickle`
- **AND** `theme` SHALL be set to `dark`

