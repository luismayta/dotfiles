## Context

`luismayta/zsh-pyenv` is an external zsh plugin providing pyenv Python version management — path setup, version listing/selection, and cache configuration. The source repo has 11+ functions under the `pyenv::` namespace. Migrating it to `zsh/modules/pyenv/` follows the same pattern as brew, rust, fnm, and goenv modules.

## Goals / Non-Goals

**Goals:**
- Port all `pyenv::*` functions into `zsh/modules/pyenv/` with config/, internal/, pkg/ structure
- Support darwin and linux OS dispatch
- Remove `luismayta/zsh-pyenv` from `zsh/zsh_plugins.txt`
- Maintain exact function names and behavior

**Non-Goals:**
- No changes to pyenv behavior or configuration
- No changes to zshenv or zshrc loader
- No changes to existing pyenv installation

## Decisions

1. **Module root var**: `ZSH_PYENV_PATH` — follows the `ZSH_FNM_PATH` precedent. `PYENV_PATH` is safe (no env var collision), but `ZSH_PYENV_PATH` is preferred for consistency with `ZSH_FNM_PATH`.
2. **Structure**: 17 files mirroring the fnm/goenv module pattern: `plugin.zsh`, `config/base.zsh`, `config/main.zsh`, `config/osx.zsh`, `config/linux.zsh`, `internal/base.zsh`, `internal/main.zsh`, `internal/osx.zsh`, `internal/linux.zsh`, `pkg/main.zsh`, `pkg/base.zsh`, `pkg/osx.zsh`, `pkg/linux.zsh`, plus `init.zsh`, `LICENSE`, `README.md`.
3. **OS dispatch**: macOS uses `brew --prefix pyenv` for path resolution; Linux uses default `~/.pyenv` or `$PYENV_ROOT`.

## Risks / Trade-offs

- `PYENV_ROOT` env var is user-facing — the module must respect it if already set, only defaulting if unset.
- Shellcheck SC2154 expected for cross-file variable references.