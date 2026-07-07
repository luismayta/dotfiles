## ADDED Requirements

### Requirement: Plugin loading deferred from BufEnter
Plugins that trigger on `BufEnter` or `BufReadPost` SHALL be moved to `VeryLazy` or `LspAttach` instead, to prevent re-initialization overhead when switching buffers in large files.

#### Scenario: Harpoon loads after startup
- **WHEN** Neovim starts and opens a file
- **THEN** harpoon.nvim is NOT loaded during `BufEnter`
- **AND** harpoon.nvim loads on `VeryLazy` before the user invokes any harpoon keymap

#### Scenario: Regexplainer loads after startup
- **WHEN** Neovim starts and opens a file
- **THEN** nvim-regexplainer is NOT loaded during `BufEnter`
- **AND** nvim-regexplainer loads on `VeryLazy` before the user needs regex inspection

#### Scenario: vim-surround loads when needed
- **WHEN** Neovim starts
- **THEN** vim-surround is NOT loaded on `BufReadPost`
- **AND** vim-surround loads lazily via its default keymaps

### Requirement: scrollEOF.nvim on VeryLazy
The SHALL load on `VeryLazy` instead of `CursorMoved`/`WinScrolled` to avoid high-frequency event processing during cursor navigation.

#### Scenario: Editing without scrollEOF overhead
- **WHEN** the user moves the cursor rapidly through a large file
- **THEN** scrollEOF.nvim does NOT process events on each cursor move
- **AND** scrollEOF.nvim is loaded and functional after Neovim startup completes
