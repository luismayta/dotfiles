## ADDED Requirements

### Requirement: Clean markdown editing with render-markdown
When editing Markdown files in neovim, `render-markdown.nvim` SHALL be active with a clean, minimal configuration that enhances readability without overwhelming the editing experience.

#### Scenario: render-markdown loads with clean config on markdown file
- **WHEN** user opens a `.md` file in neovim
- **THEN** `render-markdown.nvim` SHALL be loaded and active
- **THEN** heading rendering SHALL NOT show signs in the sign column
- **THEN** heading icons SHALL be positioned inline (not overlay)
- **THEN** heading background SHALL be block-width (not full-width)
- **THEN** inline link rendering SHALL NOT be enabled

#### Scenario: No LSP warnings from render-markdown
- **WHEN** user edits a markdown file
- **THEN** there SHALL be no warnings or diagnostic messages from `render-markdown.nvim` in the buffer

### Requirement: NeoTree opens at file location with `<leader>e`
When user presses `<leader>e`, NeoTree SHALL open toggling the directory of the currently active file, not the project root.

#### Scenario: `<leader>e` opens neotree at current file's directory
- **WHEN** user is editing a file (e.g., `/project/src/file.md`) and presses `<leader>e`
- **THEN** NeoTree SHALL open toggled at `/project/src/` (the file's directory)

#### Scenario: `<leader>e` falls back to project root on empty buffer
- **WHEN** user presses `<leader>e` on a buffer with no file (e.g., `[No Name]`)
- **THEN** NeoTree SHALL open toggled at `LazyVim.root()`

### Requirement: NeoTree opens at project root with `<leader>fe`
When user presses `<leader>fe`, NeoTree SHALL continue opening at `LazyVim.root()`, maintaining the existing behavior.

#### Scenario: `<leader>fe` opens neotree at project root
- **WHEN** user presses `<leader>fe`
- **THEN** NeoTree SHALL open toggled at `LazyVim.root()`
