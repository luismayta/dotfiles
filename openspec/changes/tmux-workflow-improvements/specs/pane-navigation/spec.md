## ADDED Requirements

### Requirement: Alt+Arrow keys navigate panes without prefix
The tmux.conf SHALL bind `M-h/j/k/l` (Alt+h/j/k/l) to navigate panes directly without requiring the prefix key, matching the existing vim-style prefix bindings.

#### Scenario: Alt+h navigates left
- **WHEN** user presses `Alt+h`
- **THEN** the focus SHALL move to the pane on the left

#### Scenario: Alt+j navigates down
- **WHEN** user presses `Alt+j`
- **THEN** the focus SHALL move to the pane below

#### Scenario: Alt+k navigates up
- **WHEN** user presses `Alt+k`
- **THEN** the focus SHALL move to the pane above

#### Scenario: Alt+l navigates right
- **WHEN** user presses `Alt+l`
- **THEN** the focus SHALL move to the pane on the right

### Requirement: Alt+Arrow keys can be disabled via environment variable
The user SHALL be able to disable Alt+Arrow navigation by setting `TMUX_NO_ALT_NAV=true` before tmux starts, to avoid conflicts with terminal emulator keybindings.

#### Scenario: Disabled via env var
- **WHEN** `TMUX_NO_ALT_NAV` is set to `true`
- **THEN** the Alt+Arrow bindings SHALL NOT be created

### Requirement: Alt+Number switches windows without prefix
The tmux.conf SHALL bind `M-0` through `M-9` (Alt+number) to switch directly to windows 0-9 without requiring the prefix key.

#### Scenario: Alt+1 switches to window 1
- **WHEN** user presses `Alt+1`
- **THEN** the session SHALL switch to window 1

#### Scenario: Alt+0 switches to window 10
- **WHEN** user presses `Alt+0`
- **THEN** the session SHALL switch to window 10

### Requirement: Prefix+Tab toggles between last two panes
The tmux.conf SHALL bind `prefix Tab` to toggle focus between the current and last active pane (equivalent to `last-pane`).

#### Scenario: Toggle last pane
- **WHEN** user presses `prefix Tab`
- **THEN** focus SHALL switch to the previously active pane

### Requirement: Prefix+{ and Prefix+} swap panes
The tmux.conf SHALL bind `prefix {` and `prefix }` to swap the current pane with the previous and next pane, respectively.

#### Scenario: Swap pane with previous
- **WHEN** user presses `prefix {`
- **THEN** the current pane SHALL swap positions with the pane to the left/above

#### Scenario: Swap pane with next
- **WHEN** user presses `prefix }`
- **THEN** the current pane SHALL swap positions with the pane to the right/below

### Requirement: Ctrl+Arrow keys resize panes with larger increments
The tmux.conf SHALL bind `C-h/j/k/l` (Ctrl+arrows) to resize panes by 10 units (vs the existing 5-unit bindings), for faster resizing when needed.

#### Scenario: Ctrl+h resizes left
- **WHEN** user presses `prefix C-h`
- **THEN** the current pane SHALL be resized 10 units to the left

#### Scenario: Ctrl+j resizes down
- **WHEN** user presses `prefix C-j`
- **THEN** the current pane SHALL be resized 10 units downward
