## Why

The current Hyprland keybinding system (`configs/binds.lua`) is monolithic — 160+ lines mixing app launchers, window management, DMS IPC calls, and layout commands in a flat structure. Meanwhile, the Hammerspoon workspace config follows a clean declarative pattern with typed sections (`config.apps`, `config.profiles`, `config.hotkeys`) and consistent modifier conventions.

This change aligns Hyprland's bind architecture with the proven Hammerspoon workspace pattern, making binds declarative, mnemonic, and maintainable — especially for app launching where the current setup lacks the organized approach Hammerspoon provides.

## What Changes

- **Introduce a declarative app-launcher bind system** following the Hammerspoon `config.apps[]` pattern: a data table of `{ mods, key, command }` entries with consistent modifier conventions (Hyper = `SUPER + ALT + CTRL` for dev tools, `SUPER + ALT` for system apps).
- **Reorganize `configs/binds.lua`** into sections mirroring the Hammerspoon structure: `profiles` (workspace layouts), `hotkeys` (action triggers), `apps` (application launchers), `window` (window management binds).
- **Create a `configs/binds/apps.lua` module** to host the declarative app bind table, keeping `binds.lua` as the orchestrator.
- **Add workspace profile support** similar to Hammerspoon's `config.profiles` — defining which apps open on which workspace/monitor per profile (developer, research, speaker).
- **Normalize modifier conventions** across all binds to use consistent patterns (e.g., `SUPER + ALT + CTRL` = hyper key for launchers, `SUPER` = window management, `SUPER + SHIFT` = window movement).
- **Terminal**: Ghostty · **Browser**: Zen

## Capabilities

### New Capabilities
- `hypr-workspace-profiles`: Declarative workspace profiles defining per-monitor app layouts, mirroring Hammerspoon's `config.profiles`.
- `hypr-app-launcher-binds`: Declarative data-driven app launcher bind table with consistent modifier conventions (Hyper Key, SUPER+ALT, etc.).
- `hypr-bind-module-architecture`: Modular bind organization with separate files per concern (apps, window, workspace, layout), loaded by an orchestrator.

### Modified Capabilities
- *(none — no existing specs are changing at the spec level)*

## Impact

- **`zsh/modules/hyprland/data/hypr/configs/binds.lua`** — restructured from flat 160-line file to orchestrator requiring sub-modules.
- **`zsh/modules/hyprland/data/hypr/configs/binds/`** — new directory with `apps.lua`, `window.lua`, `workspace.lua`, `layout.lua`.
- **`zsh/modules/hyprland/data/hypr/custom/dispatcher.lua`** — may need new dispatchers for profile-aware app launching.
- **`zsh/modules/hyprland/data/hypr/dms/binds.conf`** — may need updates if DMS IPC bind patterns change.
- **No breaking changes** — existing bind behavior preserved, only reorganized and extended.
