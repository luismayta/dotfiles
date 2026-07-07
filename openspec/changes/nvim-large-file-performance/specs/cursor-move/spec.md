## ADDED Requirements

### Requirement: Deferred gitsigns blame calculation
Gitsigns `current_line_blame` SHALL use a delay of at least 500ms to avoid computing blame on every cursor movement.

#### Scenario: Rapid cursor movement
- **WHEN** the user moves the cursor rapidly through lines in a large file
- **THEN** gitsigns does NOT calculate blame for intermediate lines
- **AND** blame is only calculated after the cursor has been stationary for 500ms

#### Scenario: Blame display on stationary cursor
- **WHEN** the user stops moving the cursor for >500ms
- **THEN** gitsigns displays the blame annotation for the current line

### Requirement: Disabled mousemoveevent
The `mousemoveevent` option SHALL be disabled to prevent unnecessary mouse-move event processing.

#### Scenario: Mouse movement without overhead
- **WHEN** the user moves the mouse over the Neovim window
- **THEN** no `MouseMove` event is fired
- **AND** no plugin or autocmd is triggered by mouse movement

### Requirement: Disabled treesitter indent
Treesitter-based indentation SHALL be disabled to reduce parse overhead on each buffer change.

#### Scenario: Editing without treesitter indent
- **WHEN** the user inserts a new line and the editor computes indentation
- **THEN** indentation is computed using Neovim's built-in indent (not treesitter)
- **AND** the indent behavior is functionally equivalent for common filetypes
