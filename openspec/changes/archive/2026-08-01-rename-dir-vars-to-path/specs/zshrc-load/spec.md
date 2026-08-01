## MODIFIED Requirements

### Requirement: Dotfiles core system loads correctly
The zshrc SHALL source `zsh/system/core/main.zsh` via `DOTFILES_CORE_PATH` environment variable. The core system SHALL be available before any plugin or module loads.

#### Scenario: Core is sourced from correct directory
- **WHEN** `zsh/zshrc` is sourced
- **THEN** it SHALL source `${DOTFILES_CORE_PATH}/main.zsh` where `DOTFILES_CORE_PATH="${DOTFILES_ZSH_PATH}/system/core"`
- **AND** `DOTFILES_MOD_PATH` SHALL be exported as a backward-compatible alias for `DOTFILES_CORE_PATH`

### Requirement: DOTFILES_SYSTEM_PATH is exported
The zshrc SHALL export `DOTFILES_SYSTEM_PATH` pointing to `zsh/system/` so that system modules can be loaded before regular modules.

#### Scenario: Variable available for system modules
- **WHEN** `zshrc` finishes loading
- **THEN** `DOTFILES_SYSTEM_PATH` SHALL equal `"${DOTFILES_ZSH_PATH}/system"`
