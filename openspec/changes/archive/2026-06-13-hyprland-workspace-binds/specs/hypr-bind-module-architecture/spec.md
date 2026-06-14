## ADDED Requirements

### Requirement: Modular bind directory structure

The system SHALL organize keybindings into a `configs/binds/` directory with separate files per concern, loaded by an orchestrator `configs/binds.lua`:

```
configs/binds/
├── apps.lua         ← Declarative app launcher bind table (hypr-app-launcher-binds)
├── window.lua       ← Window management binds (focus, move, resize, close)
├── workspace.lua    ← Workspace binds + DMS IPC + profiles (hypr-workspace-profiles)
├── layout.lua       ← Layout management binds (togglesplit, cycle layouts)
└── binds.lua        ← Orchestrator: requires all sub-modules and registers binds
```

#### Scenario: Sub-modules exist after migration
- **WHEN** inspecting the `configs/binds/` directory after migration
- **THEN** all four sub-module files exist and contain their respective bind logic

### Requirement: Orchestrator loads sub-modules in order

The `configs/binds.lua` orchestrator SHALL `require()` each sub-module in a defined order (layout → workspace → window → apps) to ensure dispatcher dependencies are available before bind registration.

The orchestrator SHALL:
1. Set `mainMod = "SUPER"` (shared variable)
2. Require each sub-module in dependency order
3. Each sub-module returns a table of `hl.bind()` calls or a bind registration function

#### Scenario: Orchestrator loads without errors
- **WHEN** Hyprland starts
- **THEN** the orchestrator loads all sub-modules without Lua errors

### Requirement: Window management binds preserved

The `configs/binds/window.lua` module SHALL contain all window management binds currently in `binds.lua`:
- Focus navigation (HJKL)
- Window movement (SHIFT + HJKL)
- Window swap (CTRL + HJKL, with by_layout scrolling awareness)
- Close (Q), Center (C), Float (T), Fullscreen (F)
- Mouse drag/resize
- Resize binds (equal/minus, SHIFT + equal/minus)
- Group management (W, BracketLeft, BracketRight)

#### Scenario: Window binds match existing behavior
- **WHEN** the user presses any window management key combination
- **THEN** the behavior is identical to before the migration

### Requirement: Workspace binds preserved

The `configs/binds/workspace.lua` module SHALL contain:
- Workspace focus/move binds (SUPER + 1-9, SHIFT + 1-9)
- Scratchpad toggle/move (SUPER + S, SHIFT + S)
- DMS IPC binds (lock, processlist, notifications, notepad, overview, clipboard, powermenu, wallpaper, settings, spotlight, screenshot)
- Multimedia keys (XF86Audio*, XF86MonBrightness*, XF86AudioMicMute, XF86AudioNext/Prev/Play/Pause)

#### Scenario: Workspace binds match existing behavior
- **WHEN** the user presses any workspace or DMS IPC key combination
- **THEN** the behavior is identical to before the migration

### Requirement: Layout management binds preserved

The `configs/binds/layout.lua` module SHALL contain:
- Togglesplit (R)
- Cycle layouts forward/backward (Backslash, SHIFT + Backslash)

#### Scenario: Layout binds match existing behavior
- **WHEN** the user presses any layout management key combination
- **THEN** the behavior is identical to before the migration

### Requirement: No hyprland.lua changes needed

The modular bind architecture SHALL NOT require changes to `hyprland.lua` — the existing `require("configs.binds")` line SHALL continue to work because `binds.lua` remains the entry point and function signature is unchanged.

#### Scenario: hyprland.lua unchanged
- **WHEN** inspecting `hyprland.lua` after migration
- **THEN** the require chain is unchanged; only `configs/binds.lua` and the new `configs/binds/` directory are modified/created
