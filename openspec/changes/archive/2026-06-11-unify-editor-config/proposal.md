## Why

The `EDITOR` environment variable fallback is currently scattered across 3 different modules (`tmux`, `ghq`, `nvim`) with inconsistent defaults (`vim` vs `nvim`). This creates confusion about which value takes effect and violates the DRY principle. The fallback should be defined once in `core` (which loads before all modules) with `nvim` as the default, and removed from module-level configs.

## What Changes

- Add `: "${EDITOR:=nvim}"` to `zsh/core/config/env.zsh` as the single source of truth
- Remove `[ -z "${EDITOR}" ] && export EDITOR="vim"` from `zsh/modules/tmux/config/base.zsh`
- Remove `[ -z "${EDITOR:-}" ] && export EDITOR="vim"` from `zsh/modules/ghq/config/base.zsh`
- Remove `: "${EDITOR:=${NVIM_PACKAGE_NAME}}"` from `zsh/modules/nvim/config/base.zsh`
- Remove conflicting `function vim` from `zsh/modules/aliases/internal/editor.zsh` — it's redundant with the nvim module's `vim` → `nvim` alias and has a recursion bug
- No breaking changes — behavior is identical (default changes from `vim` to `nvim`, which matches the project's Neovim-first direction)

## Capabilities

### New Capabilities
- `editor-config`: centralized EDITOR fallback definition with `nvim` as the default, sourced early from `zsh/core/config/env.zsh`

### Modified Capabilities
*(none)*

## Impact

- `zsh/core/config/env.zsh` — add one line: `: "${EDITOR:=nvim}"`
- `zsh/modules/tmux/config/base.zsh` — remove EDITOR fallback line 14
- `zsh/modules/ghq/config/base.zsh` — remove EDITOR fallback line 18
- `zsh/modules/nvim/config/base.zsh` — remove EDITOR fallback line 18
- `zsh/modules/aliases/internal/editor.zsh` — remove conflicting `function vim` (lines 4-10)
- After all modules remove their fallback, core's `config/env.zsh` (sourced first) will be the sole definition
