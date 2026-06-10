## Why

`zsh/mod/` is a poor name — "mod" is overloaded (modules, modifications) and doesn't describe what it is. This is the **core shared layer**: the foundational infrastructure that all ZSH feature modules (`zsh/modules/`) depend on. It provides system-level utilities (PATH manipulation, editor helpers, backup), ZSH configuration defaults (history, locale, autosuggest), and directory exports — the substrate on which everything else runs.

Renaming it to `zsh/core/` communicates intent: this is the base, the shared foundation, not a loose collection of "mod" files. The refactor also removes factory-function wrappers, splits monolithic files by domain, and aligns the sourcing pattern with `zsh/modules/core/` — making it scalable, maintainable, and self-documenting.

## What Changes

- **Rename** `zsh/mod/` → `zsh/core/` (directory rename + `DOTFILES_MOD_DIR` → `DOTFILES_CORE_DIR` in `~/.zshrc`)
- **Remove factory-function wrappers** from `zsh/core/config/main.zsh` and `zsh/core/internal/main.zsh` — switch to direct sourcing (matching `zsh/modules/core/` pattern)
- **Split** `zsh/core/internal/base.zsh` into domain-specific files: `path.zsh`, `backup.zsh`, `editor.zsh`, `reload.zsh`
- **Split** `zsh/core/internal/aliases.zsh` — migrate aliases to `zsh/modules/core/pkg/alias.zsh` and `zsh/modules/git/`
- **Split** `zsh/core/config/base.zsh` into domain-specific config files: `paths.zsh`, `history.zsh`, `language.zsh`, `autosuggest.zsh`, `git.zsh`
- **Align** naming and structure with `zsh/modules/core/` patterns (direct sourcing chain, no factory functions)
- **Ensure** all shared utilities remain accessible to both `zsh/modules/` and any other consumers

## Capabilities

### New Capabilities
- `shared-paths`: PATH manipulation, environment variable exports, directory creation logic
- `shared-utils`: Editor helpers (editrc, editprivaterc), backup/snapshot, reload shell
- `shared-config`: ZSH configuration (history, autosuggest, language, git)

### Modified Capabilities
- *(No existing specs are changing — this is a pure refactor + rename, not behavioral change)*

## Impact

- **Rename**: `zsh/mod/` → `zsh/core/` — affects `~/.zshrc` (`DOTFILES_MOD_DIR` → `DOTFILES_CORE_DIR`) and all internal paths
- **Affected files**: All 10 files under `zsh/mod/`, plus `~/.zshrc`
- **Consumers**: `zsh/modules/` indirectly via shared functions; any external `.zshrc` sourcing `zsh/core/main.zsh`
- **Breaking changes**: None in function signatures or env var behavior; the `DOTFILES_MOD_DIR` variable changes name to `DOTFILES_CORE_DIR`
- **Dependencies**: None external; relies on ZSH built-ins and existing shell utilities