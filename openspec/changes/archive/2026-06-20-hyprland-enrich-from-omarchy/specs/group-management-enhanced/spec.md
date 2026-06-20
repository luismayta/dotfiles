## ADDED Requirements

### Requirement: Move window to group directionally
The system SHALL bind `SUPER+ALT+H`/`J`/`K`/`L` to move the focused window into an adjacent group.

#### Scenario: Move window into group
- **WHEN** user presses `SUPER+ALT+<direction>` with a window adjacent to a group
- **THEN** the window SHALL be moved into that group

#### Scenario: No adjacent group
- **WHEN** user presses `SUPER+ALT+<direction>` with no adjacent group
- **THEN** nothing SHALL happen

### Requirement: Group window index selection
The system SHALL bind `SUPER+ALT+1` through `SUPER+ALT+5` to focus the Nth tab within the active group.

#### Scenario: Select group tab by index
- **WHEN** user presses `SUPER+ALT+<N>` with an active group containing at least N windows
- **THEN** the Nth window in that group SHALL become focused

#### Scenario: Index exceeds group size
- **WHEN** user presses `SUPER+ALT+<N>` with an active group containing fewer than N windows
- **THEN** nothing SHALL happen

### Requirement: Pop out focused window
The system SHALL bind `SUPER+SHIFT+F` to pop the focused window out of its group and tile it.

#### Scenario: Pop out grouped window
- **WHEN** user presses `SUPER+SHIFT+F` on a window within a group
- **THEN** the window SHALL be popped out of the group and tiled
