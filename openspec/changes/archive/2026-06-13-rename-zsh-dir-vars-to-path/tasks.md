## 1. Module-Level Variable Renames

- [x] 1.1 Rename `TMUX_CONFIG_DIR` → `TMUX_CONFIG_PATH` and `TMUXINATOR_TEMPLATE_DIR` → `TMUXINATOR_TEMPLATE_PATH` in `zsh/modules/tmux/config/base.zsh`, and update usages in `zsh/modules/tmux/pkg/helper.zsh`
- [x] 1.2 Rename `DEVOPS_K9S_CONF_DIR` → `DEVOPS_K9S_CONF_PATH` and `TF_PLUGIN_CACHE_DIR` → `TF_PLUGIN_CACHE_PATH` in `zsh/modules/devops/config/base.zsh`, and update usages in `zsh/modules/devops/pkg/k9s.zsh`
- [x] 1.3 Rename `RVM_CACHE_DIR` → `RVM_CACHE_PATH` in `zsh/modules/rvm/config/base.zsh`
- [x] 1.4 Rename `RESOURCES_FONTS_DIR` → `RESOURCES_FONTS_PATH` in `zsh/modules/resources/config/osx.zsh` and `zsh/modules/resources/config/linux.zsh`, and update usages in `zsh/modules/resources/pkg/base.zsh`
- [x] 1.5 Rename `ZSH_HOME_CONF_DIR` → `ZSH_HOME_CONF_PATH` in `zsh/modules/starship/config/base.zsh`, and update usages in `zsh/modules/starship/pkg/base.zsh`
- [x] 1.6 Rename `GHQ_CACHE_DIR` → `GHQ_CACHE_PATH` in `zsh/modules/ghq/config/base.zsh`, and update usages in `zsh/modules/ghq/pkg/base.zsh`
- [x] 1.7 Rename `GHOSTTY_THEMES_DIR` → `GHOSTTY_THEMES_PATH` in `zsh/modules/ghostty/config/base.zsh`

## 2. Core Variable Renames

- [x] 2.1 Rename `DOTFILES_BACKUP_DIR` → `DOTFILES_BACKUP_PATH` in `zsh/core/config/paths.zsh` and update usages in `zsh/core/config/main.zsh` and `zsh/core/internal/backup.zsh`
- [x] 2.2 Rename `DOTFILES_CACHE_DIR` → `DOTFILES_CACHE_PATH` in `zsh/core/config/paths.zsh` and update usages in `zsh/core/config/main.zsh`
- [x] 2.3 Rename `DOTFILES_CORE_DIR` → `DOTFILES_CORE_PATH` in `zsh/core/config/paths.zsh` and update usages across all sourcing files in `zsh/core/` (`main.zsh`, `config/main.zsh`, `internal/main.zsh`, `internal/api.zsh`, `internal/editor.zsh`, `pkg/main.zsh`, `pkg/helper/main.zsh`)
- [x] 2.4 Rename `DOTFILES_MOD_DIR` → `DOTFILES_MOD_PATH` in `zsh/core/config/paths.zsh` (single definition, no external usages found)

## 3. Validation

- [x] 3.1 Verify no stale `_DIR` references remain in `zsh/` tree after all renames
- [x] 3.2 Run `task validate` to confirm no regressions
- [ ] 3.3 Reload shell and verify dotfiles source correctly
