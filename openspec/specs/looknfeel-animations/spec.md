## ADDED Requirements

### Requirement: Animation curves
The system SHALL configure animation curves with bezier curves and per-type animation settings (windows, borders, fade, workspaces) matching omarchy defaults.

#### Scenario: Windows animate
- **WHEN** a window opens, closes, or moves
- **THEN** the animation SHALL use the configured bezier curve and duration

#### Scenario: Borders animate
- **WHEN** a window becomes focused or unfocused
- **THEN** the border color transition SHALL animate

#### Scenario: Fade in/out
- **WHEN** a window fades in or out
- **THEN** the fade SHALL use the configured layers (windows, popups, menus)

#### Scenario: Workspace switch
- **WHEN** user switches workspaces
- **THEN** the workspace SHALL slide with the configured curve and duration

### Requirement: Groupbar styling
The system SHALL configure groupbar with font family, colors, indicator height, and gradient direction matching omarchy defaults.

#### Scenario: Groupbar rendered
- **WHEN** a window group is active
- **THEN** the groupbar SHALL display with configured font, colors, and indicator

### Requirement: Cursor configuration
The system SHALL configure cursor to hide on key press and warp on workspace change.

#### Scenario: Hide cursor on key press
- **WHEN** user presses a key
- **THEN** the cursor SHALL hide after the configured delay

#### Scenario: Warp cursor on workspace change
- **WHEN** user switches workspaces
- **THEN** the cursor SHALL warp to the center of the focused window on the new workspace

### Requirement: Misc config
The system SHALL disable the Hyprland logo, enable `focus_on_activate`, and configure `animate_manual_resizes`, `apply_limits_to_window`, `disable_xdg_anr` settings.

#### Scenario: Logo disabled
- **WHEN** Hyprland starts
- **THEN** the logo SHALL NOT be displayed

#### Scenario: Focus on activate
- **WHEN** a window requests focus
- **THEN** the system SHALL pass focus to that window (focus_on_activate = true)
