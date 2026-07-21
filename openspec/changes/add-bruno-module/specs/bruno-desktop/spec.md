## ADDED Requirements

### Requirement: Install Bruno desktop app on Linux
The system SHALL install Bruno desktop app using snap or flatpak on Linux.

#### Scenario: Snap installation on Linux
- **WHEN** user runs `bruno::setup` on Linux and snap is available
- **THEN** system executes `snap install bruno`

#### Scenario: Flatpak fallback on Linux
- **WHEN** user runs `bruno::setup` on Linux and snap is not available but flatpak is
- **THEN** system executes `flatpak install com.usebruno.Bruno`

#### Scenario: No package manager available
- **WHEN** user runs `bruno::setup` on Linux and neither snap nor flatpak is available
- **THEN** system displays message to install snap or flatpak first

### Requirement: Install Bruno desktop app on macOS
The system SHALL install Bruno desktop app using Homebrew on macOS.

#### Scenario: Brew installation on macOS
- **WHEN** user runs `bruno::setup` on macOS
- **THEN** system executes `brew install --cask bruno`

#### Scenario: Brew not available on macOS
- **WHEN** user runs `bruno::setup` on macOS and brew is not installed
- **THEN** system displays error message requesting Homebrew installation

### Requirement: Bruno desktop public API
The system SHALL expose public functions for Bruno desktop installation.

#### Scenario: bruno::desktop::install function exists
- **WHEN** user types `type bruno::desktop::install`
- **THEN** system reports "bruno::desktop::install is a shell function"

### Requirement: Skip desktop installation if not wanted
The system SHALL allow users to install only CLI without desktop app.

#### Scenario: Setup with CLI only
- **WHEN** user runs `bruno::install`
- **THEN** system installs only Bruno CLI, not desktop app

#### Scenario: Setup with both CLI and desktop
- **WHEN** user runs `bruno::setup`
- **THEN** system installs both Bruno CLI and desktop app
