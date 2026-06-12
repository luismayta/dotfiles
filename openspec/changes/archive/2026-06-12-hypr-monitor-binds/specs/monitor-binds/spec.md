## ADDED Requirements

### Requirement: Toggle window between monitors
The system SHALL bind ALT+O to toggle the active window between monitors. If the window is on monitor 1, it moves to monitor 2. If pressed again, it moves back to monitor 1.

#### Scenario: Toggle from primary to secondary
- **WHEN** user presses ALT+O with an active window on the primary monitor
- **THEN** the window moves to the secondary monitor

#### Scenario: Toggle back to primary
- **WHEN** user presses ALT+O again with the window now on the secondary monitor
- **THEN** the window moves back to the primary monitor

#### Scenario: Cycle forward with 3+ monitors
- **WHEN** user presses ALT+O on a system with three or more monitors
- **THEN** the window moves forward to the next monitor in the list (1→2→3→1)

#### Scenario: No-op on single monitor
- **WHEN** user presses ALT+O on a system with only one monitor connected
- **THEN** no change occurs (graceful no-op, no error)

### Requirement: Maximize active window
The system SHALL bind ALT+M to maximize the active window, filling the workspace area while keeping the bar/panel visible.

#### Scenario: Maximize tiled window
- **WHEN** user presses ALT+M on a tiled window
- **THEN** the window expands to fill the workspace (excluding panel/bar area)

#### Scenario: Maximize floating window
- **WHEN** user presses ALT+M on a floating window
- **THEN** the window snaps to fill the workspace (excluding panel/bar area)

#### Scenario: Toggle maximize off
- **WHEN** user presses ALT+M on an already-maximized window
- **THEN** the window returns to its previous size and position

### Requirement: Key constants
All modifier keys SHALL be defined as module-level constants at the top of the file, not inlined in bind registration calls.

#### Scenario: Constants precede usage
- **WHEN** reading the monitor.lua module
- **THEN** all modifier key strings are defined as local constants before any `hl.bind()` call

### Requirement: Integration with orchestrator
The module SHALL export a `register(mainMod)` function following the existing sub-module convention, loaded by `configs/binds.lua`.

#### Scenario: Module loaded on startup
- **WHEN** Hyprland starts with `require("configs.binds").register(mainMod)` in the load chain
- **THEN** the ALT+O and ALT+M bindings are active
