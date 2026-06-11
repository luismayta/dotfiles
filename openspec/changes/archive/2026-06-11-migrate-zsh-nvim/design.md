## Context

The `hadenlabs/zsh-nvim` repository provides a ZSH module for Neovim management: auto-installation of `nvim`, cloning/upgrading the `nvimrc` configuration repo, cache cleanup, a `vim` command alias, and an `editnvim` helper. It follows the same 3-layer pattern (config → internal → pkg) as other external modules already migrated (brew, git, rvm).

The module is being ported into `zsh/modules/nvim/` to consolidate all ZSH module configuration under the dotfiles monorepo, following the conventions established by previous migrations.

## Goals / Non-Goals

**Goals:**
- Port all functionality from `hadenlabs/zsh-nvim` into `zsh/modules/nvim/` with zero behavioral changes
- Adopt monorepo conventions: flat OS dispatch, `# shellcheck shell=bash` shebangs, idempotency guard
- Remove external plugin dependency from `zsh/zsh_plugins.txt` if present
- Module auto-loads via `zsh/modules/nvim/plugin.zsh` discovery

**Non-Goals:**
- Fix the undefined `NVIM_FILE_SETTINGS` variable in `editnvim` helper (existing bug in source — preserve as-is)
- Change the nvimrc repo URL or branch strategy
- Modify the git clone approach for nvimrc configuration
- Add new capabilities beyond what the source module provides

## Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Module variable name | `ZSH_NVIM_PATH` | Consistent with brew (`BREW_PATH`), git (`ZSH_GIT_PATH`), rvm (`ZSH_RVM_PATH`) patterns in the monorepo |
| Initialization pattern | Flat dispatch (no factory functions) | Follows brew/rvm convention; eliminates unnecessary function wrapper |
| Private/public layers | `internal/` for core logic, `pkg/` for public API | Standard dotfiles pattern; `pkg/base.zsh` exposes `nvim::install`, `nvim::upgrade`, `nvim::clean` |
| OS dispatch | `case "${OSTYPE}"` in `config/main.zsh`, `internal/main.zsh`, `pkg/main.zsh` | Matches all existing migrated modules; OS-specific overrides in separate files |
| Auto-install trigger | `internal/main.zsh` ensures `nvim` and `rsync`, clones nvimrc if missing | Preserves source behavior exactly |
| `vim` alias | `pkg/alias.zsh` defining `function vim { nvim ${@} }` | Separate file for aliases per module convention; sourced from `pkg/main.zsh` |
| `editnvim` helper | `pkg/helper.zsh` with `editnvim()` function | Separate file for helper functions; preserves source behavior including the undefined `NVIM_FILE_SETTINGS` bug |
| Config env vars | Flat exports in `config/base.zsh` | Same as brew/rvm; no factory function needed |

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| `NVIM_FILE_SETTINGS` referenced in `editnvim` but never defined | Documented non-goal; preserved from source to avoid behavioral drift; fix in a future change if needed |
| `NVIM_MESSAGE_BREW`, `NVIM_MESSAGE_RVM`, `NVIM_MESSAGE_YAY` vars unused in migrated code | Omitted from migration — these were unused in source (only defined, never referenced) |
| `nvimrc` git clone may fail if network unavailable | The source already handles this with a warning and return; preserved |
| GPG key servers for rvm signing (in rvm module) vs nvim — no cross-dependency here | Neovim install uses `core::install nvim` (brew on macOS), no GPG dependency |