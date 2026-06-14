## ADDED Requirements

### Requirement: Full Zed setup
The system SHALL provide a single `zed::setup` function that orchestrates installation and configuration.

#### Scenario: Fresh setup (Zed not installed)
- **WHEN** `zed::setup` is called and Zed is not installed
- **THEN** the system installs Zed Editor
- **THEN** the system symlinks configuration files
- **THEN** the system reports setup complete

#### Scenario: Setup with Zed already installed
- **WHEN** `zed::setup` is called and Zed is already installed
- **THEN** the system skips installation and reports "Zed Editor is already installed"
- **THEN** the system proceeds with configuration symlink
- **THEN** the system reports setup complete

### Requirement: Module idempotent loading
The system SHALL prevent double-loading of the zed module.

#### Scenario: Guard variable prevents re-entry
- **WHEN** `plugin.zsh` is sourced a second time
- **THEN** the guard variable `__ZSH_ZED_LOADED` is already set
- **THEN** the script exits immediately without re-sourcing files
