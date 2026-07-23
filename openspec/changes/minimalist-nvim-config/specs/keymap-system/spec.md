## ADDED Requirements

### Requirement: Centralized keymap definitions
The system SHALL define all keymaps in `core/keymaps.lua` with clear descriptions.

#### Scenario: Keymap file location
- **WHEN** a developer looks for keymaps
- **THEN** they find them in `lua/core/keymaps.lua`

#### Scenario: Keymap descriptions
- **WHEN** a keymap is defined
- **THEN** it includes a `desc` field for which-key discoverability

### Requirement: Leader key configuration
The system SHALL set leader key to space before any keymaps are defined.

#### Scenario: Leader key
- **WHEN** nvim starts
- **THEN** `vim.g.mapleader` is set to `" "` (space)

### Requirement: Essential vim keymaps
The system SHALL include essential vim keymaps for navigation and editing.

#### Scenario: Visual line movement
- **WHEN** user presses `J` or `K` in visual mode
- **THEN** selected lines move down/up

#### Scenario: Centered scrolling
- **WHEN** user presses `<C-d>` or `<C-u>`
- **THEN** cursor moves half-page and stays centered

#### Scenario: Search centering
- **WHEN** user presses `n` or `N` after a search
- **THEN** next/previous match is centered

#### Scenario: Indent in visual mode
- **WHEN** user presses `<` or `>` in visual mode
- **THEN** selection is indented/dedented and remains selected

#### Scenario: Paste without yank
- **WHEN** user pastes over a selection in visual mode
- **THEN** the yanked text is preserved (using `_dP` trick)

#### Scenario: Delete without yank
- **WHEN** user presses `<leader>d` in normal or visual mode
- **THEN** text is deleted without copying to clipboard

### Requirement: Window management keymaps
The system SHALL provide keymaps for window splits and navigation.

#### Scenario: Split vertically
- **WHEN** user presses `<leader>sv`
- **THEN** window splits vertically

#### Scenario: Split horizontally
- **WHEN** user presses `<leader>sh`
- **THEN** window splits horizontally

#### Scenario: Equalize splits
- **WHEN** user presses `<leader>se`
- **THEN** all splits are resized equally

#### Scenario: Close split
- **WHEN** user presses `<leader>sx`
- **THEN** current split is closed

### Requirement: Tab management keymaps
The system SHALL provide keymaps for tab management (optional, can be removed if not used).

#### Scenario: New tab
- **WHEN** user presses `<leader>to`
- **THEN** a new tab is opened

#### Scenario: Close tab
- **WHEN** user presses `<leader>tx`
- **THEN** current tab is closed

#### Scenario: Next/previous tab
- **WHEN** user presses `<leader>tn` or `<leader>tp`
- **THEN** next/previous tab is selected

### Requirement: Utility keymaps
The system SHALL provide utility keymaps for common operations.

#### Scenario: Format file
- **WHEN** user presses `<leader>f`
- **THEN** current buffer is formatted (via conform.nvim or LSP)

#### Scenario: Copy file path
- **WHEN** user presses `<leader>fp`
- **THEN** file path is copied to clipboard

#### Scenario: Make file executable
- **WHEN** user presses `<leader>X`
- **THEN** current file is made executable via `chmod +x`

#### Scenario: Global replace word
- **WHEN** user presses `<leader>s`
- **THEN** the word under cursor is replaced globally (with confirmation)

#### Scenario: Restart LSP
- **WHEN** user presses `<leader>lr`
- **THEN** LSP servers are restarted

#### Scenario: Clear search highlight
- **WHEN** user presses `<C-c>`
- **THEN** search highlight is cleared
