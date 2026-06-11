## Context

Currently, the `EDITOR` environment variable fallback is defined in 3 modules (tmux, ghq, nvim) with different defaults (`vim` vs `nvim`). Dotfiles uses `zsh/core/` as the foundational layer sourced first — all module configs load after core. Moving the EDITOR fallback to core ensures it's set once before any module reads it.

The nvim module already has the correct intent (default = `nvim`) but places it inside the nvim-specific config, so it only applies if the nvim module is enabled.

## Goals / Non-Goals

**Goals:**
- Single source of truth for `EDITOR` fallback in `zsh/core/config/env.zsh`
- Default value changed from `vim` to `nvim` (consistent with project direction)
- Remove 3 duplicate definitions from tmux, ghq, and nvim modules
- Zero behavior change for users who already set `EDITOR` explicitly

**Non-Goals:**
- Not changing how `EDITOR` is consumed anywhere (editrc, editnvim, editgit, etc.)
- Not introducing new config mechanisms or env var patterns

## Decisions

- **Placement: `zsh/core/config/env.zsh`** — already hosts all core env var exports and is sourced before any module. No new file needed.
- **Expression: `: "${EDITOR:=nvim}"`** — uses POSIX-style default assignment (same as nvim's current form). Won't override an already-set `EDITOR`.
- **Why `nvim` not `vim`**: The project is Neovim-first. All interactive usage (`vim` alias in nvim module, `fo` in core helpers) already delegates to `nvim`. The fallback should match.

## Risks / Trade-offs

- [Low] A user relying on the old `vim` default without explicitly setting `EDITOR` will now get `nvim`. For this dotfiles repo, `vim` is aliased to `nvim` anyway, so the effective behavior is unchanged.
- [None] No rollback needed — if reverted, modules still have their own fallbacks (the reverse operation would require removing the core line and restoring module lines).

## Migration Plan

1. Add `: "${EDITOR:=nvim}"` to `zsh/core/config/env.zsh`
2. Remove `[ -z "${EDITOR}" ] && export EDITOR="vim"` from `zsh/modules/tmux/config/base.zsh`
3. Remove `[ -z "${EDITOR:-}" ] && export EDITOR="vim"` from `zsh/modules/ghq/config/base.zsh`
4. Remove `: "${EDITOR:=${NVIM_PACKAGE_NAME}}"` from `zsh/modules/nvim/config/base.zsh`
5. Verify with `source zshrc && echo $EDITOR` that it returns `nvim` when unset
