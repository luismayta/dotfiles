## ADDED Requirements

### Requirement: Launch hunk show for a commit

The system SHALL provide a Neovim command `:HunkShow` that launches `hunk show <ref>` in a floating terminal window using Snacks.terminal.

The command SHALL accept an optional commit reference argument. If no argument is provided, it SHALL default to `HEAD`.

The system SHALL define a keymap `<leader>hs` that prompts for a commit reference and then runs `:HunkShow <ref>`.

The system SHALL verify that `hunk` is available via `vim.fn.executable("hunk")` before executing, and SHALL display a warning notification if not found.

#### Scenario: Show HEAD commit diff

- **WHEN** user runs `:HunkShow` without arguments
- **THEN** a floating terminal window opens running `hunk show HEAD`

#### Scenario: Show specific commit

- **WHEN** user runs `:HunkShow abc123`
- **THEN** a floating terminal window opens running `hunk show abc123`

#### Scenario: Show commit via keymap with input

- **WHEN** user presses `<leader>hs`
- **THEN** Neovim SHALL prompt for a commit reference via `vim.ui.input`
- **AND** after entering a reference, a floating terminal opens running `hunk show <ref>`
- **AND** if the user cancels the input prompt, no terminal SHALL be opened
