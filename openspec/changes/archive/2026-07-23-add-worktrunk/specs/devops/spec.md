## MODIFIED Requirements

### Requirement: Module provides DevOps tooling aliases and helpers

The devops module SHALL provide ZSH aliases and helper functions for common DevOps tooling, including platform-specific configuration for Linux and macOS. The `DEVOPS_TOOLS` array SHALL include Atuin and Worktrunk for lifecycle management.

#### Scenario: DevOps aliases available
- **WHEN** the module is loaded
- **THEN** the user can invoke DevOps-related aliases defined in `pkg/` and `internal/`

#### Scenario: Platform-specific tooling paths
- **WHEN** the system is macOS
- **THEN** macOS-specific DevOps paths from `pkg/osx.zsh` and `internal/osx.zsh` are available
- **WHEN** the system is Linux
- **THEN** Linux-specific DevOps paths from `pkg/linux.zsh` and `internal/linux.zsh` are available

#### Scenario: Atuin in DEVOPS_TOOLS
- **WHEN** the `DEVOPS_TOOLS` array is inspected
- **THEN** `atuin` SHALL be present in the array

#### Scenario: Worktrunk in DEVOPS_TOOLS
- **WHEN** the `DEVOPS_TOOLS` array is inspected
- **THEN** `worktrunk` SHALL be present in the array
