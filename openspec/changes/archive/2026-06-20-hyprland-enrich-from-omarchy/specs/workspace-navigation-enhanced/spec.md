## ADDED Requirements

### Requirement: Next/previous workspace
The system SHALL bind `SUPER+CTRL+BRIGHTNESSDOWN` for previous workspace and `SUPER+CTRL+BRIGHTNESSUP` for next workspace navigation.

#### Scenario: Navigate to next workspace
- **WHEN** user presses `SUPER+CTRL+BRIGHTNESSUP`
- **THEN** the system SHALL move to the next workspace

#### Scenario: Navigate to previous workspace
- **WHEN** user presses `SUPER+CTRL+BRIGHTNESSDOWN`
- **THEN** the system SHALL move to the previous workspace

### Requirement: Former workspace
The system SHALL bind `SUPER+SHIFT+TAB` to swap to the previously focused workspace.

#### Scenario: Swap to former workspace
- **WHEN** user presses `SUPER+SHIFT+TAB`
- **THEN** the system SHALL swap to the previously focused workspace

### Requirement: Move window and follow to workspace
The system SHALL preserve existing `movewindow_or_monitor` behavior and ensure focus follows the window when moved to another workspace.

#### Scenario: Move window to workspace silently
- **WHEN** user moves a window to another workspace
- **THEN** focus SHALL remain on the original workspace unless `focus_on_move` is explicitly triggered

### Requirement: Move window to next/previous monitor
The system SHALL keep existing `SUPER+SHIFT+[` and `SUPER+SHIFT+]` for moving windows between monitors.

#### Scenario: Move window across monitors
- **WHEN** user presses `SUPER+SHIFT+[`
- **THEN** the focused window SHALL move to the previous monitor
- **WHEN** user presses `SUPER+SHIFT+]`
- **THEN** the focused window SHALL move to the next monitor

### Requirement: Focus next/previous monitor
The system SHALL bind `CTRL+ALT+TAB` to focus the next monitor and `CTRL+ALT+SHIFT+TAB` to focus the previous monitor.

#### Scenario: Focus next monitor
- **WHEN** user presses `CTRL+ALT+TAB`
- **THEN** focus SHALL move to the next monitor

#### Scenario: Focus previous monitor
- **WHEN** user presses `CTRL+ALT+SHIFT+TAB`
- **THEN** focus SHALL move to the previous monitor

### Requirement: Move workspace to adjacent monitor
The system SHALL bind `SUPER+SHIFT+ALT+LEFT/RIGHT/UP/DOWN` to move the current workspace to the monitor in that direction.

#### Scenario: Move workspace to monitor
- **WHEN** user presses `SUPER+SHIFT+ALT+LEFT`
- **THEN** the current workspace SHALL move to the monitor on the left
- **WHEN** user presses `SUPER+SHIFT+ALT+RIGHT`
- **THEN** the current workspace SHALL move to the monitor on the right
