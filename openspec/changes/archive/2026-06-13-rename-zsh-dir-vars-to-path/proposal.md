## Why

Standardize naming convention across the zsh codebase: variables holding filesystem paths should use the `_PATH` suffix (e.g., `DOTFILES_CORE_DIR` → `DOTFILES_CORE_PATH`). The current mix of `_DIR` and `_PATH` suffixes is inconsistent and makes it unclear whether a variable holds a directory path, a file path, or something else. This refactoring makes the codebase self-documenting and consistent with common shell scripting conventions.

## What Changes

- Rename all 13 `*_DIR` exported variables to `*_PATH` across core and module config files
- Update every reference to these variables across the entire `zsh/` tree
- No behavioral or functional changes — pure naming convention alignment

| Current Name | New Name |
|---|---|
| `DOTFILES_BACKUP_DIR` | `DOTFILES_BACKUP_PATH` |
| `DOTFILES_CACHE_DIR` | `DOTFILES_CACHE_PATH` |
| `DOTFILES_CORE_DIR` | `DOTFILES_CORE_PATH` |
| `DOTFILES_MOD_DIR` | `DOTFILES_MOD_PATH` |
| `TMUX_CONFIG_DIR` | `TMUX_CONFIG_PATH` |
| `TMUXINATOR_TEMPLATE_DIR` | `TMUXINATOR_TEMPLATE_PATH` |
| `RVM_CACHE_DIR` | `RVM_CACHE_PATH` |
| `DEVOPS_K9S_CONF_DIR` | `DEVOPS_K9S_CONF_PATH` |
| `TF_PLUGIN_CACHE_DIR` | `TF_PLUGIN_CACHE_PATH` |
| `RESOURCES_FONTS_DIR` | `RESOURCES_FONTS_PATH` |
| `ZSH_HOME_CONF_DIR` | `ZSH_HOME_CONF_PATH` |
| `GHQ_CACHE_DIR` | `GHQ_CACHE_PATH` |
| `GHOSTTY_THEMES_DIR` | `GHOSTTY_THEMES_PATH` |

## Capabilities

No new capabilities or behavior changes. This is a pure refactor — the interface contract (variable values, data flow) remains identical; only the naming changes.

### New Capabilities

None.

### Modified Capabilities

None. No spec-level behavior changes.

## Impact

- **~30 files** in `zsh/` tree need changes (variable definitions + all usages)
- Primary affected areas:
  - `zsh/core/config/paths.zsh` — 4 variable definitions (core paths)
  - `zsh/core/config/main.zsh` — references to backup/cache dirs
  - `zsh/core/internal/backup.zsh` — backup dir usage
  - `zsh/core/internal/main.zsh` — core dir sourcing
  - `zsh/core/internal/api.zsh` — Brewfile path
  - `zsh/core/internal/editor.zsh` — core dir reference
  - `zsh/core/pkg/main.zsh` — core dir sourcing
  - `zsh/core/pkg/helper/main.zsh` — core dir sourcing
  - `zsh/core/main.zsh` — core dir sourcing
  - `zsh/modules/tmux/config/base.zsh` — 2 var definitions
  - `zsh/modules/tmux/pkg/helper.zsh` — template dir usage
  - `zsh/modules/devops/config/base.zsh` — 2 var definitions
  - `zsh/modules/devops/pkg/k9s.zsh` — k9s conf dir usage
  - `zsh/modules/rvm/config/base.zsh` — 1 var definition
  - `zsh/modules/resources/config/osx.zsh` — 1 var definition
  - `zsh/modules/resources/config/linux.zsh` — 1 var definition
  - `zsh/modules/resources/pkg/base.zsh` — fonts dir usage
  - `zsh/modules/starship/config/base.zsh` — 1 var definition
  - `zsh/modules/starship/pkg/base.zsh` — conf dir usage
  - `zsh/modules/ghq/config/base.zsh` — 1 var definition + usage
  - `zsh/modules/ghq/pkg/base.zsh` — cache dir usage
  - `zsh/modules/ghostty/config/base.zsh` — 1 var definition
- No external APIs, dependencies, or runtime behavior affected
