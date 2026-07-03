## ADDED Requirements

### Requirement: Ctrl-X window split prefix
The system SHALL provide `CTRL+X` as a prefix key in normal mode for window split operations.
The prefix SHALL NOT interfere with `<C-x>` insert-mode mappings for Codeium completion.

#### Scenario: Ctrl+X prefix works in normal mode
- **WHEN** user presses `<C-x>` in normal mode
- **THEN** the system SHALL wait for a secondary key to determine the window operation
- **AND** the system SHALL NOT execute any action until the secondary key is pressed

#### Scenario: Ctrl+X does not interfere with insert mode
- **WHEN** user presses `<C-x>` in insert mode
- **THEN** the system SHALL execute the Codeium clear completion action (`codeium#Clear()`)
- **AND** the system SHALL NOT trigger any window split operation

### Requirement: Maximize/restore windows via Ctrl-X + 1
The system SHALL close all other windows (keep only the current one) when the user presses `CTRL+X` followed by `1` in normal mode.

#### Scenario: Close other windows with multiple windows open
- **WHEN** user has multiple windows open and presses `<C-x>1` in normal mode
- **THEN** the system SHALL close all windows except the current one (`<C-w>o`)
- **AND** the current window SHALL expand to fill the available space

#### Scenario: No action with single window
- **WHEN** user has only one window open and presses `<C-x>1` in normal mode
- **THEN** the system SHALL NOT close any windows (no operation)

### Requirement: Vertical split via Ctrl-X + 2
The system SHALL create a vertical window split when the user presses `CTRL+X` followed by `2` in normal mode.

#### Scenario: Vertical split
- **WHEN** user presses `<C-x>2` in normal mode
- **THEN** the current window SHALL be split vertically (`:vsplit`)
- **AND** the cursor SHALL move to the new window on the right

#### Scenario: Vertical split with multiple buffers
- **WHEN** user presses `<C-x>2` in normal mode
- **THEN** the system SHALL display the same buffer in the new vertical split

### Requirement: Horizontal split via Ctrl-X + 3
The system SHALL create a horizontal window split when the user presses `CTRL+X` followed by `3` in normal mode.

#### Scenario: Horizontal split
- **WHEN** user presses `<C-x>3` in normal mode
- **THEN** the current window SHALL be split horizontally (`:split`)
- **AND** the cursor SHALL move to the new window above

#### Scenario: Horizontal split when buffer is modified
- **WHEN** user presses `<C-x>3` in normal mode and the current buffer has unsaved changes
- **THEN** the system SHALL still split the window horizontally
- **AND** the buffer content SHALL be preserved in both windows
