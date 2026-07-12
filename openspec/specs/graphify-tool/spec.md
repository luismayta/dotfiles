## ADDED Requirements

### Requirement: Install graphify via UV
The system SHALL install graphify using `uv tool install "graphifyy[all]" --force`.

#### Scenario: Fresh installation
- **WHEN** user runs `ai::graphify::install` and graphify is not installed
- **THEN** system SHALL execute `uv tool install "graphifyy[all]" --force` and report success

#### Scenario: Reinstallation with force
- **WHEN** user runs `ai::graphify::install` and graphify is already installed
- **THEN** system SHALL reinstall with `--force` flag and report success

#### Scenario: UV not available
- **WHEN** user runs `ai::graphify::install` and `uv` is not in PATH
- **THEN** system SHALL display error message indicating UV is required

### Requirement: Configure graphify PATH
The system SHALL add graphify binary path to PATH environment variable.

#### Scenario: PATH configuration on load
- **WHEN** internal/main.zsh loads graphify module
- **THEN** system SHALL add `${HOME}/.local/bin` to PATH if graphify binary exists

### Requirement: Register graphify skill with OpenCode
The system SHALL register graphify as a skill with OpenCode assistant.

#### Scenario: Skill registration
- **WHEN** user runs `ai::graphify::install` successfully
- **THEN** system SHALL execute `graphify install --platform opencode` to register the skill

### Requirement: Provide public wrapper functions
The system SHALL expose public functions for graphify operations.

#### Scenario: Install function available
- **WHEN** user sources the AI module
- **THEN** `ai::graphify::install` function SHALL be available

#### Scenario: Upgrade function available
- **WHEN** user sources the AI module
- **THEN** `ai::graphify::upgrade` function SHALL be available (alias for install with force)

### Requirement: Idempotent installation
The system SHALL skip installation if graphify is already present and up-to-date.

#### Scenario: Already installed check
- **WHEN** user runs `ai::graphify::install`
- **THEN** system SHALL check if graphify is installed and skip if already present (unless force flag)
