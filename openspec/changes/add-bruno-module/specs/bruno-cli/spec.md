## ADDED Requirements

### Requirement: Install Bruno CLI via npm
The system SHALL install Bruno CLI globally using npm when not already present.

#### Scenario: Bruno CLI not installed
- **WHEN** user runs `bruno::install` and `bru` command is not in PATH
- **THEN** system executes `npm install -g @usebruno/cli` and verifies installation

#### Scenario: Bruno CLI already installed
- **WHEN** user runs `bruno::install` and `bru` command exists in PATH
- **THEN** system skips installation and reports "already installed"

### Requirement: Verify Bruno CLI installation
The system SHALL verify Bruno CLI is functional after installation.

#### Scenario: Successful verification
- **WHEN** Bruno CLI installation completes
- **THEN** system runs `bru --version` and confirms output contains version number

#### Scenario: Installation failure
- **WHEN** npm install command fails
- **THEN** system displays error message and returns non-zero exit code

### Requirement: Bruno CLI public API
The system SHALL expose standard public functions for Bruno CLI management.

#### Scenario: bruno::install function exists
- **WHEN** user types `type bruno::install`
- **THEN** system reports "bruno::install is a shell function"

#### Scenario: bruno::setup function exists
- **WHEN** user types `type bruno::setup`
- **THEN** system reports "bruno::setup is a shell function"

### Requirement: Auto-install on module load
The system SHALL automatically install Bruno CLI when module loads if not present.

#### Scenario: Module loads without Bruno CLI
- **WHEN** shell sources `plugin.zsh` and `bru` is not in PATH
- **THEN** system automatically runs installation

#### Scenario: Module loads with Bruno CLI
- **WHEN** shell sources `plugin.zsh` and `bru` exists in PATH
- **THEN** system skips installation and loads module normally
