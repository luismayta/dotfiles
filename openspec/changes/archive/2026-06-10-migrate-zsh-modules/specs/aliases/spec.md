## ADDED Requirements

### Requirement: Module provides ZSH aliases for common tools
The aliases module SHALL provide organized alias definitions grouped by category (base, docker, editor, eza, helper) with platform-specific overrides for Linux and macOS.

#### Scenario: Aliases load on shell start
- **WHEN** a new ZSH shell starts
- **THEN** the aliases module sources `plugin.zsh` which loads all alias definitions from `pkg/` and `internal/`
- **THEN** the user can use defined aliases immediately

#### Scenario: Platform-specific aliases activate per OS
- **WHEN** the system is macOS
- **THEN** macOS-specific aliases from `pkg/osx.zsh` and `internal/osx.zsh` are loaded
- **WHEN** the system is Linux
- **THEN** Linux-specific aliases from `pkg/linux.zsh` and `internal/linux.zsh` are loaded

### Requirement: Module follows existing dotfiles convention
The aliases module SHALL be self-contained within `zsh/modules/aliases/` with `plugin.zsh` as the entry point and `config/`, `internal/`, `pkg/` subdirectories.

#### Scenario: Entry point exists
- **WHEN** the module directory is inspected
- **THEN** `zsh/modules/aliases/plugin.zsh` exists and is executable

#### Scenario: Subdirectory structure is complete
- **WHEN** the module files are enumerated
- **THEN** `config/`, `internal/`, and `pkg/` subdirectories contain the expected platform-specific files
