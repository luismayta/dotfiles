## ADDED Requirements

### Requirement: Full setup orchestration
The system SHALL provide a `hammerspoon::setup` function that orchestrates the complete module setup: install if missing, sync config, and run post-install hooks.

#### Scenario: Clean setup on macOS
- **WHEN** `hammerspoon::setup` is called on macOS and Hammerspoon is not installed
- **THEN** the system SHALL install Hammerspoon, sync config, and report success

#### Scenario: Setup with existing installation
- **WHEN** `hammerspoon::setup` is called on macOS and Hammerspoon is already installed
- **THEN** the system SHALL skip installation, sync config, and report success

### Requirement: Post-install hook
The system SHALL provide a `hammerspoon::post_install` function that triggers config sync after installation.

#### Scenario: Post-install completes
- **WHEN** `hammerspoon::post_install` is called
- **THEN** the system SHALL sync config and report completion
