# cleanup-platform Specification

## Purpose
TBD - created by archiving change improve-zsh-clean-module. Update Purpose after archive.
## Requirements
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

