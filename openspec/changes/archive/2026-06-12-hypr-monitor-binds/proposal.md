## Why

Hyprland currently lacks dedicated keybindings for window-to-monitor movement and window maximize. The user needs quick keyboard shortcuts to move the active window between monitors (ALT+O) and maximize it (ALT+M) without reaching for the mouse or relying on workspace-based workflows.

## What Changes

- Add new `configs/binds/monitor.lua` sub-module with two keybindings:
  - **ALT + O**: Toggle active window between monitors (cycles forward with 3+ monitors)
  - **ALT + M**: Maximize active window (fill workspace area, keep bar visible)
- Define all modifier keys as module-level constants (no inline strings)
- Load via `configs/binds.lua` orchestrator in existing require chain
- No changes to existing binds, no config files, no DMS IPC

## Capabilities

### New Capabilities
- `monitor-binds`: Two keybindings for monitor-level window management — move to other monitor and maximize

### Modified Capabilities
*(none — this is purely additive, no existing capability changes)*

## Impact

- **New file**: `configs/binds/monitor.lua` (~30 lines)
- **Modified file**: `configs/binds.lua` — add one `require("configs.binds.monitor").register(mainMod)` line
- **Zero impact** on existing bindings, workspaces, DMS IPC, or Hyprland config
