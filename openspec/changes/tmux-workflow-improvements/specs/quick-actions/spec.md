## ADDED Requirements

### Requirement: Copy current pane path to clipboard
The tmux.conf SHALL provide a binding `prefix .` (period) to copy the current pane's working directory path to the system clipboard.

#### Scenario: Copy pane path
- **WHEN** user presses `prefix .`
- **THEN** the current pane's working directory path SHALL be captured
- **AND** copied to the system clipboard
- **AND** a display message SHALL confirm the path was copied

### Requirement: Copy pane visible content to clipboard
The tmux.conf SHALL provide a binding `prefix C-o` to capture the entire visible content of the current pane and copy it to the system clipboard (not just the scrollback buffer).

#### Scenario: Copy visible pane content
- **WHEN** user presses `prefix C-o`
- **THEN** the visible content of the current pane SHALL be captured
- **AND** copied to the system clipboard

### Requirement: Toggle synchronize-panes with visual feedback
The existing `prefix y` for `synchronize-panes` SHALL show a display message indicating whether sync is now ON or OFF, so the user knows the current state without guessing.

#### Scenario: Toggle sync on
- **WHEN** user presses `prefix y`
- **AND** synchronize-panes was OFF
- **THEN** synchronize-panes SHALL be enabled
- **AND** a message SHALL display "Synchronize-panes ON"

#### Scenario: Toggle sync off
- **WHEN** user presses `prefix y`
- **AND** synchronize-panes was ON
- **THEN** synchronize-panes SHALL be disabled
- **AND** a message SHALL display "Synchronize-panes OFF"

### Requirement: Quick zoom toggle for current pane
The tmux.conf SHALL provide `prefix z` (lowercase) to zoom/unzoom the current pane (already a default tmux binding, SHALL be kept as-is and documented for discoverability).

#### Scenario: Zoom current pane
- **WHEN** user presses `prefix z`
- **THEN** the current pane SHALL zoom to full window size
- **AND** pressing `prefix z` again SHALL unzoom it

### Requirement: Display current bindings reference
The tmux.conf SHALL provide `prefix ?` (already a default tmux binding) to show all key bindings. The SHALL document this for discoverability.

#### Scenario: Show bindings
- **WHEN** user presses `prefix ?`
- **THEN** a list of all active key bindings SHALL be displayed

### Requirement: Quick kill current pane with confirmation
The tmux.conf SHALL provide `prefix x` (already a default tmux binding) to kill the current pane with a confirmation prompt. This SHALL be kept as-is.

#### Scenario: Kill pane with prompt
- **WHEN** user presses `prefix x`
- **THEN** a confirmation prompt SHALL appear
- **AND** the pane SHALL only be killed after confirmation
