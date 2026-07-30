## MODIFIED Requirements

### Requirement: Dotfiles core system loads correctly
The zshrc SHALL source `zsh/system/core/main.zsh` via `DOTFILES_CORE_DIR` environment variable. The core system SHALL be available before any plugin or module loads.

**FROM:**
- `DOTFILES_CORE_DIR="${DOTFILES_ZSH_DIR}/core"`
- Sources `${DOTFILES_CORE_DIR}/main.zsh`

**TO:**
- `DOTFILES_CORE_DIR="${DOTFILES_ZSH_DIR}/system/core"`
- `DOTFILES_SYSTEM_DIR="${DOTFILES_ZSH_DIR}/system"`
- Sources `${DOTFILES_CORE_DIR}/main.zsh`
- Then sources `$DOTFILES_SYSTEM_DIR/*/plugin.zsh` (excluding core) before regular modules

#### Scenario: Core is sourced from new system directory
- **WHEN** `zsh/zshrc` is sourced
- **THEN** it SHALL source `${DOTFILES_CORE_DIR}/main.zsh` where `DOTFILES_CORE_DIR="${DOTFILES_ZSH_DIR}/system/core"`
- **AND** `DOTFILES_MOD_DIR` SHALL be exported as a backward-compatible alias for `DOTFILES_CORE_DIR`

#### Scenario: System plugins load after core, before regular modules
- **WHEN** `zshrc` finishes loading core
- **THEN** it SHALL iterate `zsh/system/*/plugin.zsh` (excluding `core/`)
- **AND** only THEN iterate `zsh/modules/*/plugin.zsh`

## ADDED Requirements

### Requirement: DOTFILES_SYSTEM_DIR is exported
The zshrc SHALL export `DOTFILES_SYSTEM_DIR` pointing to `zsh/system/` so other components can reference system modules.

#### Scenario: Variable available for system modules
- **WHEN** `zshrc` finishes loading
- **THEN** `DOTFILES_SYSTEM_DIR` SHALL equal `"${DOTFILES_ZSH_DIR}/system"`
