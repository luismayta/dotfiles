## ADDED Requirements

### Requirement: Launch hunk diff on working tree

The system SHALL provide a Neovim command `:HunkDiff` that launches `hunk diff` in a floating terminal window using Snacks.terminal.

The system SHALL define a keymap `<leader>hd` as a shortcut for `:HunkDiff`.

The system SHALL verify that `hunk` is available via `vim.fn.executable("hunk")` before executing, and SHALL display a warning notification if not found.

The floating terminal SHALL use the same border style as other Neovim floating elements (rounded).

#### Scenario: Successful hunk diff launch

- **WHEN** user runs `:HunkDiff` or presses `<leader>hd`
- **AND** hunk is installed and in `$PATH`
- **THEN** a floating terminal window opens running `hunk diff`
- **AND** the user can interact with hunk's TUI inside the terminal

#### Scenario: Hunk not installed

- **WHEN** user runs `:HunkDiff` or presses `<leader>hd`
- **AND** `vim.fn.executable("hunk")` returns `0`
- **THEN** Neovim SHALL display a warning notification: "hunk not found — install via `ai::hunk::install` or `npm i -g hunkdiff`"
- **AND** no terminal window SHALL be opened

### Requirement: Watch mode support

The system SHALL support a `--watch` flag for `:HunkDiff` that launches `hunk diff --watch`, enabling auto-reload on file changes.

The system SHALL define a keymap `<leader>hw` for `:HunkDiff --watch`.

#### Scenario: Launch hunk diff in watch mode

- **WHEN** user runs `:HunkDiff --watch` or presses `<leader>hw`
- **THEN** a floating terminal window opens running `hunk diff --watch`
- **AND** the terminal auto-refreshes when files change on disk

### Requirement: Close hunk terminal

The system SHALL define a keymap `<leader>hq` to close the hunk floating terminal if it's open.

#### Scenario: Close hunk terminal

- **WHEN** the hunk floating terminal is open
- **AND** user presses `<leader>hq`
- **THEN** the floating terminal SHALL be closed
