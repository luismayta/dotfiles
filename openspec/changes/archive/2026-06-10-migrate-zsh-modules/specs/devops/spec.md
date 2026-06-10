## ADDED Requirements

### Requirement: Module provides DevOps tooling aliases and helpers
The devops module SHALL provide ZSH aliases and helper functions for common DevOps tooling, including platform-specific configuration for Linux and macOS.

#### Scenario: DevOps aliases available
- **WHEN** the module is loaded
- **THEN** the user can invoke DevOps-related aliases defined in `pkg/` and `internal/`

#### Scenario: Platform-specific tooling paths
- **WHEN** the system is macOS
- **THEN** macOS-specific DevOps paths from `pkg/osx.zsh` and `internal/osx.zsh` are available
- **WHEN** the system is Linux
- **THEN** Linux-specific DevOps paths from `pkg/linux.zsh` and `internal/linux.zsh` are available

### Requirement: Module follows existing dotfiles convention
The devops module SHALL be self-contained within `zsh/modules/devops/` with `plugin.zsh` as the entry point and `config/`, `internal/`, `pkg/` subdirectories.

#### Scenario: Entry point exists
- **WHEN** the module directory is inspected
- **THEN** `zsh/modules/devops/plugin.zsh` exists and is executable

#### Scenario: Subdirectory structure is complete
- **WHEN** the module files are enumerated
- **THEN** `config/`, `internal/`, and `pkg/` subdirectories contain the expected platform-specific files
