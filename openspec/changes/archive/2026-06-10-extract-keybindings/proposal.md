## Why

Keybindings (`bindkey` + `zle -N`) are currently scattered across module entry points (`plugin.zsh`) and implementation files (`pkg/base.zsh`), making them hard to discover, maintain, and override. Extracting them into a dedicated `keybindings.zsh` file per module creates a single, predictable location for all keybinding registrations.

Currently:
- **ssh**, **templates**, **bitwarden**: keybindings in `plugin.zsh`
- **ghq**: keybinding in `pkg/base.zsh`

## What Changes

- Create a `keybindings.zsh` in each module that registers ZLE widgets
- Move `zle -N` and `bindkey` calls from `plugin.zsh` and `pkg/base.zsh` into `keybindings.zsh`
- Source `keybindings.zsh` from each module's `plugin.zsh` (after `pkg/main.zsh`)
- Standardize the registration pattern across all modules

**Modules affected:**
- `zsh/modules/ghq/` — migrate `bindkey '^Xp'` from `pkg/base.zsh` to new `keybindings.zsh`
- `zsh/modules/ssh/` — migrate `bindkey '^Xs'` from `plugin.zsh` to new `keybindings.zsh`
- `zsh/modules/templates/` — migrate `bindkey '^Xt'` from `plugin.zsh` to new `keybindings.zsh`
- `zsh/modules/bitwarden/` — migrate `bindkey '^Xk'` from `plugin.zsh` to new `keybindings.zsh`

**Non-goals:**
- No changes to keybinding values themselves
- No changes to module behavior or public API
- No migration of the `chpwd` hook in `issues/` (not a keybinding)

## Capabilities

### New Capabilities
- `keybindings`: Standardized per-module keybinding registration — each module with ZLE widgets gets a `keybindings.zsh` file containing `zle -N` + `bindkey` calls, sourced from the plugin chain.

### Modified Capabilities
*(None — no spec-level behavior changes)*

## Impact

- **4 new files**: `zsh/modules/<name>/keybindings.zsh` (ghq, ssh, templates, bitwarden)
- **4 modified files**: 3 `plugin.zsh` + 1 `pkg/base.zsh` — bindkey lines removed, source line added
- Zero impact on `zshrc` or module loading mechanism
