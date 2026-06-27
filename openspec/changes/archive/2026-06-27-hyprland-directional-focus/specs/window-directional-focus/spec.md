## ADDED Requirements

### Requirement: Window focus with HYPER + HJKL
The system SHALL move keyboard focus between windows in the specified direction when the user presses `HYPER (SUPER + ALT + CTRL) + H/J/K/L`.

The HJKL-to-direction mapping SHALL use Hyprland's focus direction parameters:
- `H` → `l` (left)
- `J` → `d` (down)
- `K` → `u` (up)
- `L` → `r` (right)

#### Scenario: Focus moves left (H)
- **WHEN** user presses `SUPER + ALT + CTRL + H`
- **THEN** focus moves to the window on the left of the currently focused window

#### Scenario: Focus moves down (J)
- **WHEN** user presses `SUPER + ALT + CTRL + J`
- **THEN** focus moves to the window below the currently focused window

#### Scenario: Focus moves up (K)
- **WHEN** user presses `SUPER + ALT + CTRL + K`
- **THEN** focus moves to the window above the currently focused window

#### Scenario: Focus moves right (L)
- **WHEN** user presses `SUPER + ALT + CTRL + L`
- **THEN** focus moves to the window on the right of the currently focused window

#### Scenario: No-op when no window in direction
- **WHEN** user presses `SUPER + ALT + CTRL + H` and there is no window to the left
- **THEN** focus remains on the current window

### Requirement: Move window with HYPER + SHIFT + HJKL
The system SHALL move the active window in the specified direction when the user presses `HYPER + SHIFT + H/J/K/L`.

#### Scenario: Move window left (H)
- **WHEN** user presses `SUPER + ALT + CTRL + SHIFT + H`
- **THEN** the active window moves to the left position, swapping with any window in that space if using dwindle layout

#### Scenario: Move window down (J)
- **WHEN** user presses `SUPER + ALT + CTRL + SHIFT + J`
- **THEN** the active window moves to the position below

#### Scenario: Move window up (K)
- **WHEN** user presses `SUPER + ALT + CTRL + SHIFT + K`
- **THEN** the active window moves to the position above

#### Scenario: Move window right (L)
- **WHEN** user presses `SUPER + ALT + CTRL + SHIFT + L`
- **THEN** the active window moves to the right position

### Requirement: Existing SUPER + HJKL binds remain unchanged
The existing `SUPER + H/J/K/L` (focus) and `SUPER + SHIFT + H/J/K/L` (move) binds SHALL continue to work exactly as before. The new HYPER + HJKL binds are additive only.

#### Scenario: HJKL focus still works
- **WHEN** user presses `SUPER + H`
- **THEN** focus moves left (same behavior as before the change)

#### Scenario: HJKL move still works
- **WHEN** user presses `SUPER + SHIFT + H`
- **THEN** window moves left (same behavior as before the change)
