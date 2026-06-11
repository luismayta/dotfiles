## Context

The dotfiles project has 22 zsh modules under `zsh/modules/*/`, each following a consistent 3-layer sourcing chain (`config/` → `internal/` → `pkg/`). Four modules register ZLE widgets and keybindings:

| Module | Current Location | Keybinding | Widget |
|--------|-----------------|------------|--------|
| ghq | `pkg/base.zsh` (line 183) | `^Xp` | `ghq::find::project` |
| ssh | `plugin.zsh` (line 12-13) | `^Xs` | `ssh::connect` |
| templates | `plugin.zsh` (line 28-29) | `^Xt` | `templates::run` |
| bitwarden | `plugin.zsh` (line 28-29) | `^Xk` | `fbw` (alias) |

This inconsistency makes keybindings hard to discover and maintain.

## Goals / Non-Goals

**Goals:**
- Create `zsh/modules/<name>/keybindings.zsh` in each of the 4 affected modules
- Move all `zle -N` + `bindkey` calls into each module's `keybindings.zsh`
- Source `keybindings.zsh` from `plugin.zsh` after `pkg/main.zsh`
- Remove the now-redundant bindkey lines from their current locations

**Non-Goals:**
- No changes to keybinding values or widget functions
- No changes to modules without keybindings
- No changes to `zshrc` or the module loading loop

## Decisions

### Decision 1: Source keybindings.zsh from plugin.zsh (not pkg/main.zsh)

**Chosen:** Source `keybindings.zsh` directly from `plugin.zsh`, after the `pkg/main.zsh` source line.

**Rationale:**
- `plugin.zsh` is the single entry point — all sourcing decisions visible at a glance
- The widget functions must be defined before `zle -N` and `bindkey` run
- Sourcing from `pkg/main.zsh` would couple pkg/ concerns with UI registration
- Pattern matches how other frameworks structure their keybinding files

**Alternatives considered:**
- Source from `pkg/main.zsh` — rejected: mixes domain logic with UI registration

### Decision 2: File naming and location

**Chosen:** `keybindings.zsh` at module root (same level as `plugin.zsh`).

**Rationale:**
- Discoverable — one file per module, predictable name
- Module root is the convention for entry-point files
- Easy to find with `find . -name keybindings.zsh`

### Decision 3: Registration pattern

```zsh
# keybindings.zsh
# shellcheck shell=bash
zle -N <widget-name>
bindkey '^X<x>' <widget-name>
```

**Rationale:** Simple, idempotent, no guard needed (plugin.zsh already guards the module).

## Risks / Trade-offs

- **[Low] Ordering dependency**: `keybindings.zsh` must be sourced AFTER `pkg/main.zsh`. Mitigated by explicit ordering in `plugin.zsh`.
- **[Low] Module churn**: 4 modules touched. Each change is mechanical and verifiable.
- **[None] Breaking change**: Keybinding values, widget names, and behavior remain identical.