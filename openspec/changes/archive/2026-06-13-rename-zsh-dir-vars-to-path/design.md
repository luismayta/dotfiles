## Context

The zsh codebase uses a mix of `_DIR` and `_PATH` suffixes for variables that hold filesystem paths. This inconsistency makes it unclear whether a variable points to a directory, a file, or something else. The majority of modern shell scripting conventions favor `_PATH` for filesystem locations.

There are 13 `*_DIR` exported variables distributed across:
- `zsh/core/config/paths.zsh` (4 core variables: `DOTFILES_BACKUP_DIR`, `DOTFILES_CACHE_DIR`, `DOTFILES_CORE_DIR`, `DOTFILES_MOD_DIR`)
- Various `zsh/modules/*/config/base.zsh` files (9 module-specific variables)

Each variable is referenced in its defining module's `pkg/` or `internal/` files, and the core variables are referenced extensively across the entire `zsh/` tree.

All values are already directory paths — no file path variables would be incorrectly renamed.

## Goals / Non-Goals

**Goals:**
- Rename all 13 `*_DIR` exported variables to `*_PATH` across the zsh codebase
- Update every internal reference to these renamed variables
- Maintain identical runtime behavior (no value changes, no variable removal)

**Non-Goals:**
- No architectural changes to how variables are defined or sourced
- No addition or removal of variables
- No changes to external-facing interfaces or APIs
- No changes to non-zsh files (e.g., Taskfile, YAML, TOML)
- Does NOT address the existing bug where `DOTFILES_MOD_DIR` is incorrectly set to `zsh/core/` instead of `zsh/modules/` (out of scope)

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Rename strategy | Direct rename in-place | All references are internal (no external consumers). Single pass: change definition + all usages, then commit. No deprecation period needed. |
| Variable name pattern | `_PATH` suffix | Follows existing convention in the codebase (e.g., `HOME_CONFIG_PATH`, `DOTFILES_ZSH_DIR` → changes to `DOTFILES_ZSH_PATH`, `GHOSTTY_DATA_PATH`). Consistent with common shell convention. |
| Execution order | Rename leaf variables first, then core variables | Module variables (`TMUX_CONFIG_DIR` → `TMUX_CONFIG_PATH`) only reference themselves, not each other. Core variables (`DOTFILES_CORE_DIR` → `DOTFILES_CORE_PATH`) are referenced across many files — rename them last after all local references are updated. |
| Commit strategy | Single atomic commit per module, then one for core | Minimizes merge conflicts. Each commit is self-contained: one module's variables are renamed in both definition and all usages. |

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| Missed reference outside `zsh/` tree | Search the entire repo for `_DIR` patterns after rename. The variables are only exported from zsh configs and only used in zsh files. |
| `DOTFILES_MOD_DIR` is a bug (points to core) | Noted but out of scope — this rename doesn't fix that. Only renames the variable. |
| Stale/cached shell state | User must reload shell (`exec zsh` or `source ~/.zshrc`) after rename. Add note in commit message. |
| `DEVOPS_K9S_CONF_DIR` has escaped spaces in value | Must preserve exact escaping (`${HOME}/Library/Application\ Support/k9s` → same value, just new variable name). Use `export DEVOPS_K9S_CONF_PATH=${HOME}/Library/Application\ Support/k9s` (no quotes, preserves escape). |
