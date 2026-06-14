## Context

The Hyprland configuration at `zsh/modules/hyprland/data/hypr/` uses a dual-format system: active Lua configs (`configs/*.lua`, `custom/*.lua`) and legacy/reference `.conf` files (`conf/*.conf`, `dms/*.conf`). The Lua entry point `hyprland.lua` requires sub-modules in sequence.

Currently `configs/binds.lua` is a single 160-line file with two sections:
1. **Window/Workspace management binds** (lines 10-91): hardcoded `hl.bind()` calls with the `mainMod` variable (`SUPER`).
2. **Execution binds** (lines 93-160): a flat `exec_binds` table mixing app launchers (kitty, zen-browser, dolphin), DMS IPC calls (lock, notifications, clipboard, powermenu, spotlight, etc.), and multimedia keys (XF86Audio*, XF86MonBrightness*).

The Hammerspoon workspace config (`src/config/workspace/init.lua`) demonstrates a clean declarative pattern:
- `config.apps[]`: array of `{ mods, key, app }` entries with consistent modifier conventions
- `config.profiles`: workspace-level app layouts per profile
- `config.hotkeys`: action triggers (e.g., profile switching)
- `config.spoons`: external tool config

This design adapts that pattern to Hyprland's Lua-based config system.

## Goals / Non-Goals

**Goals:**
- Restructure `configs/binds.lua` into a modular architecture with separate files per concern
- Create a declarative app-launcher bind table matching the Hammerspoon `config.apps[]` pattern
- Add workspace profile support for profile-aware app launching
- Normalize modifier conventions across all binds
- Preserve all existing bind behavior (no regressions)

**Non-Goals:**
- No changes to the DMS IPC system or its configuration format
- No changes to `hyprland.lua` orchestrator or other config modules (general, rules, colors, envs, execs)
- No changes to the `.conf` files in `conf/` or `dms/` (legacy/reference only)
- No changes to the custom dispatcher logic (`custom/dispatcher.lua`, `custom/helper.lua`, `custom/layout.lua`) — only may add new dispatchers
- No Hammerspoon feature parity — only the workspace/launcher pattern, not the window management or spoon system

## Decisions

### Decision 1: Sub-module directory structure

**Choice:** Create `configs/binds/` directory with `apps.lua`, `window.lua`, `workspace.lua`, `layout.lua` sub-modules, loaded by a refactored `binds.lua` orchestrator.

**Rationale:**
- Mirrors Hammerspoon's module-per-concern approach
- Keeps `binds.lua` as the single entry point (no changes to `hyprland.lua` require chain)
- Each sub-module is focused (~40-60 lines) and independently testable
- Easy to add new bind categories without touching existing files

### Decision 2: Declarative app launcher table

**Choice:** Model `configs/binds/apps.lua` after Hammerspoon's `config.apps[]` with `{ mods, key, exec }` entries, using three modifier tiers:

| Tier | Modifier | Purpose | Example |
|------|----------|---------|---------|
| Hyper | `SUPER + ALT + CTRL` | Dev tools (IDEs, terminal, DB) | `SUPER+ALT+CTRL+T` → kitty |
| Secondary | `SUPER + ALT` | System apps (browser, discord, mail) | `SUPER+ALT+A` → Arc |
| Tertiary | `SUPER + CTRL` | Utilities (screenshots, clipboard) | `SUPER+CTRL+P` → screenshot |

**Rationale:**
- Hammerspoon uses `ctrl+alt+cmd` as Hyper; Hyprland uses `SUPER` as main mod — `SUPER+ALT+CTRL` is the closest equivalent
- Three tiers provide semantic grouping without overcomplicating
- Backward compatible: all existing binds with `mainMod` prefix still work

### Decision 3: Workspace profiles as data tables

**Choice:** Define `configs/binds/workspace.lua` with a `profiles` table matching Hammerspoon's structure, and a `dispatch_profile(name)` function that executes `hl.dsp.exec_cmd()` for each app in the profile.

**Rationale:**
- Pure data — no logic in the profile definitions
- Same structure as Hammerspoon makes mental model transfer seamless
- `dispatch_profile` is a simple loop: for each app, `hl.exec_cmd(app)` with optional workspace targeting

### Decision 4: Existing exec_binds migration strategy

**Choice:** Split the current `exec_binds` table into three destinations:
- App launchers (lines 97-100) → `apps.lua` declarative table
- DMS IPC calls (lines 104-118) → `workspace.lua` as `dms_binds` table
- Multimedia keys (lines 121-151) → `window.lua` as media control section

**Rationale:**
- Each group has a different modifier convention and purpose
- DMS IPC binds are workspace/system actions, not app launchers
- Multimedia keys are hardware bindings that don't use `mainMod`

## Risks / Trade-offs

- **[Complexity]** Adding sub-modules increases file count but reduces cognitive load per file. Mitigation: orchestrator in `binds.lua` centralizes the require chain.
- **[Consistency]** Existing binds use `mainMod = "SUPER"` while new app launchers use multi-modifier combinations. Mitigation: document modifier conventions at the top of each file.
- **[Migration]** Moving binds between files could cause merge conflicts with active branches. Mitigation: single-commit migration with no behavior changes.
- **[DMS IPC coupling]** DMS IPC calls are hardcoded strings — any DMS API changes require updating binds. Mitigation: centralize DMS IPC command strings in a single table for easy updates.
