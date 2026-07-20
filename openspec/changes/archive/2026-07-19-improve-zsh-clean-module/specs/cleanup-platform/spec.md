## ADDED Requirements

### Requirement: Linux trash cleanup implementation
The system SHALL implement actual trash cleanup for Linux systems.

#### Scenario: Clean user trash
- **WHEN** user runs `cleanup::system::trash` on Linux
- **AND** trash-cli is installed
- **THEN** system runs `trash-empty` to clear user trash
- **AND** displays success message

#### Scenario: trash-cli not installed
- **WHEN** user runs `cleanup::system::trash` on Linux
- **AND** trash-cli is not installed
- **THEN** system attempts manual cleanup of `${HOME}/.local/share/Trash`
- **AND** displays warning about installing trash-cli for safer operation

#### Scenario: Manual trash cleanup fallback
- **WHEN** trash-cli is not available
- **AND** user runs `cleanup::system::trash` on Linux
- **THEN** system removes files from `${HOME}/.local/share/Trash/files`
- **AND** removes files from `${HOME}/.local/share/Trash/info`
- **AND** displays count of removed items

### Requirement: Linux log cleanup implementation
The system SHALL implement actual log cleanup for Linux systems.

#### Scenario: Clean system logs
- **WHEN** user runs `cleanup::system::logs` on Linux
- **THEN** system cleans `${HOME}/.cache/mozilla/firefox/*/Cache`
- **AND** cleans `${HOME}/.cache/google-chrome/Default/Cache`
- **AND** cleans `${HOME}/.cache/thumbnails`
- **AND** displays success message

#### Scenario: Clean journal logs
- **WHEN** user runs `cleanup::system::logs` on Linux
- **AND** journalctl is available
- **THEN** system runs `journalctl --vacuum-time=7d`
- **AND** displays success message

## ADDED Requirements

### Requirement: Platform-specific function integration
The system SHALL call all platform-specific functions from cleanup::all.

#### Scenario: macOS functions called from cleanup::all
- **WHEN** user runs `cleanup::all` on macOS
- **THEN** system calls `cleanup::osx::trash`
- **AND** calls `cleanup::osx::logs`
- **AND** calls `cleanup::osx::adobe_cache`
- **AND** calls `cleanup::osx::ios_backup`
- **AND** calls `cleanup::osx::xcode`

#### Scenario: Linux functions called from cleanup::all
- **WHEN** user runs `cleanup::all` on Linux
- **THEN** system calls `cleanup::linux::trash`
- **AND** calls `cleanup::linux::logs`
- **AND** calls `cleanup::linux::thumbnails`

### Requirement: Cross-platform function aliases
The system SHALL provide consistent function names across platforms.

#### Scenario: Generic trash function works on both platforms
- **WHEN** user runs `cleanup::system::trash`
- **AND** system is macOS
- **THEN** system executes macOS trash cleanup

#### Scenario: Generic trash function works on Linux
- **WHEN** user runs `cleanup::system::trash`
- **AND** system is Linux
- **THEN** system executes Linux trash cleanup

### Requirement: Platform detection and routing
The system SHALL detect platform and route to appropriate implementations.

#### Scenario: macOS detection
- **WHEN** `OSTYPE` contains "darwin"
- **THEN** system loads macOS-specific functions
- **AND** routes generic calls to macOS implementations

#### Scenario: Linux detection
- **WHEN** `OSTYPE` contains "linux"
- **THEN** system loads Linux-specific functions
- **AND** routes generic calls to Linux implementations
