## ADDED Requirements

### Requirement: Auto-detect Hammerspoon installation
The system SHALL detect whether Hammerspoon is already installed on macOS by checking for the Hammerspoon.app bundle.

#### Scenario: Hammerspoon is installed
- **WHEN** the module loads on macOS and Hammerspoon.app exists in /Applications
- **THEN** the system SHALL skip installation and report Hammerspoon as available

#### Scenario: Hammerspoon is not installed
- **WHEN** the module loads on macOS and Hammerspoon.app is not found
- **THEN** the system SHALL trigger automatic installation via `brew install --cask hammerspoon`

### Requirement: Install via Homebrew cask
The system SHALL install Hammerspoon using the Homebrew cask command on macOS.

#### Scenario: Successful installation
- **WHEN** `brew install --cask hammerspoon` completes successfully
- **THEN** the system SHALL report success

#### Scenario: Installation failure
- **WHEN** `brew install --cask hammerspoon` fails
- **THEN** the system SHALL report an error and return a non-zero exit code

### Requirement: No-op on Linux
The system SHALL NOT attempt to install Hammerspoon on Linux.

#### Scenario: Module loads on Linux
- **WHEN** the module loads on a Linux system
- **THEN** the system SHALL skip Hammerspoon installation silently
