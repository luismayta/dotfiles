## ADDED Requirements

### Requirement: Rename current window with shortcut
The tmux.conf SHALL provide `prefix ,` (comma) as a binding to rename the current window with an inline prompt (overrides default `,` which does nothing in tmux by default).

#### Scenario: Rename window
- **WHEN** user presses `prefix ,`
- **THEN** a prompt SHALL appear to enter a new name for the current window

### Requirement: Rename current session with shortcut
The tmux.conf SHALL provide `prefix $` (dollar sign) as a binding to rename the current session with an inline prompt (already a default tmux binding, SHALL be kept).

#### Scenario: Rename session
- **WHEN** user presses `prefix $`
- **THEN** a prompt SHALL appear to enter a new name for the current session

### Requirement: Quick window creation with name prompt
The existing `prefix c` (new window) SHALL remain. Additionally, `prefix C` (capital C) already prompts for session name — this SHALL be kept.

#### Scenario: Create window with default name
- **WHEN** user presses `prefix c`
- **THEN** a new window SHALL be created with an unnamed placeholder
- **AND** the working directory SHALL be the current pane's path

### Requirement: Better session switching with fzf
The `ftm` function SHALL be enhanced to show session preview (windows list) in the fzf preview panel, making it easier to choose the right session.

#### Scenario: ftm with preview
- **WHEN** user runs `ftm` without arguments
- **THEN** a fzf list SHALL show all sessions
- **AND** a preview panel SHALL show the windows of the selected session
- **AND** selecting a session SHALL switch to it

### Requirement: Window navigation with fzf
The tmux.conf SHALL provide `prefix W` (capital W) to fuzzy-find and jump to a specific window across all sessions using fzf.

#### Scenario: Fuzzy-find window
- **WHEN** user presses `prefix W`
- **THEN** a fzf list SHALL show all windows across all sessions
- **AND** selecting a window SHALL switch to that window

### Requirement: Kill window with confirmation
The tmux.conf SHALL provide `prefix X` (capital X) with a prompt to confirm before killing the current window (improving on the current implementation which kills the entire session).

#### Scenario: Kill window with confirmation
- **WHEN** user presses `prefix X`
- **THEN** a confirmation prompt SHALL appear to kill the current window
- **AND** the window SHALL be killed only upon confirmation

### Requirement: ftmk with preview
The `ftmk` function SHALL be enhanced to show session preview (windows list) in the fzf preview panel, making it clearer which session will be killed.

#### Scenario: ftmk with preview
- **WHEN** user runs `ftmk` without arguments
- **THEN** a fzf list SHALL show all sessions
- **AND** a preview panel SHALL show the windows of the selected session
- **AND** selecting a session SHALL kill it
