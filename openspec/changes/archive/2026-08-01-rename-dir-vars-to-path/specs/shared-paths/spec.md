## MODIFIED Requirements

### Requirement: Standard directory variables
The shared paths layer SHALL export standard directory environment variables in `zsh/system/core/config/paths.zsh`:
- `DOTFILES_CORE_PATH` set to `${DOTFILES_ZSH_PATH}/system/core`
- `DOTFILES_MOD_PATH` set to `${DOTFILES_CORE_PATH}` (backward compat alias)
- `DOTFILES_BACKUP_PATH` set to `${HOME}/.backup`
- `DOTFILES_CACHE_PATH` set to `${HOME}/.cache/dotfiles`
- `LOCAL_PATH_BIN` set to `${HOME}/.local/bin`
- `HOMEBREW_BIN_PATH` set to `/opt/homebrew/bin`
- `PRIVATERC` set to `${HOME}/.privaterc`
- `CUSTOMRC` set to `${HOME}/.customrc`

#### Scenario: DOTFILES_CORE_PATH is exported
- **WHEN** `zsh/system/core/config/paths.zsh` is sourced
- **THEN** `DOTFILES_CORE_PATH` SHALL be exported as the absolute path to the `core/` directory

#### Scenario: DOTFILES_MOD_PATH is backward-compat alias
- **WHEN** `zsh/system/core/config/paths.zsh` is sourced
- **THEN** `DOTFILES_MOD_PATH` SHALL be exported with the same value as `DOTFILES_CORE_PATH`

#### Scenario: Standard dirs are exported on shell start
- **WHEN** `zsh/system/core/config/paths.zsh` is sourced
- **THEN** `DOTFILES_CORE_PATH`, `DOTFILES_MOD_PATH`, `DOTFILES_BACKUP_PATH`, `DOTFILES_CACHE_PATH`, `LOCAL_PATH_BIN`, `HOMEBREW_BIN_PATH`, `PRIVATERC`, and `CUSTOMRC` SHALL be exported as environment variables
