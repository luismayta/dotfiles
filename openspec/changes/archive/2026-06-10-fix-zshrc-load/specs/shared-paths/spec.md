## MODIFIED Requirements

### Requirement: Standard directory variables
**EDIT**: Adding `DOTFILES_CORE_DIR` — no changes to existing variables.

The shared paths layer SHALL export standard directory environment variables in `zsh/core/config/paths.zsh`:
- `DOTFILES_CORE_DIR` set to `${DOTFILES_ZSH_DIR}/core`
- `DOTFILES_MOD_DIR` set to `${DOTFILES_CORE_DIR}` (backward compat alias)
- `DOTFILES_BACKUP_DIR` set to `${HOME}/.backup`
- `DOTFILES_CACHE_DIR` set to `${HOME}/.cache/dotfiles`
- `LOCAL_PATH_BIN` set to `${HOME}/.local/bin`
- `HOMEBREW_BIN_PATH` set to `/opt/homebrew/bin`
- `PRIVATERC` set to `${HOME}/.privaterc`
- `CUSTOMRC` set to `${HOME}/.customrc`

#### Scenario: DOTFILES_CORE_DIR is exported
- **WHEN** `zsh/core/config/paths.zsh` is sourced
- **THEN** `DOTFILES_CORE_DIR` SHALL be exported as the absolute path to the `core/` directory

#### Scenario: DOTFILES_MOD_DIR is backward-compat alias
- **WHEN** `zsh/core/config/paths.zsh` is sourced
- **THEN** `DOTFILES_MOD_DIR` SHALL be exported with the same value as `DOTFILES_CORE_DIR`
