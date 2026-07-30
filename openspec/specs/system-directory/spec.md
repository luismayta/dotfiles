## ADDED Requirements

### Requirement: zsh/system/ directory exists
The system SHALL contain a `zsh/system/` directory that holds modules requiring early loading, before regular modules.

#### Scenario: System directory exists
- **WHEN** the dotfiles are installed
- **THEN** `zsh/system/` SHALL exist
- **AND** contain at least `core/`, `nix/`, and `nix-darwin/`

### Requirement: System modules load before regular modules
The `zshrc` SHALL load all modules from `zsh/system/*/plugin.zsh` before loading modules from `zsh/modules/*/plugin.zsh`.

#### Scenario: System modules load first
- **WHEN** `zshrc` is sourced
- **THEN** `zsh/system/core/main.zsh` SHALL load first
- **THEN** `zsh/system/nix/plugin.zsh` SHALL load before any `zsh/modules/*/plugin.zsh`
- **THEN** `zsh/system/nix-darwin/plugin.zsh` SHALL load before any `zsh/modules/*/plugin.zsh`

### Requirement: System modules respect ZSH_DISABLED_MODULES
System modules SHALL respect the same enable/disable pattern as regular modules.

#### Scenario: Disabled system module skipped
- **WHEN** `ZSH_DISABLED_MODULES` contains "nix"
- **THEN** `zsh/system/nix/plugin.zsh` SHALL NOT be sourced
