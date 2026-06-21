## ADDED Requirements

### Requirement: Utility functions module
The system SHALL provide a `lua/jasper/utils.lua` module with reusable helper functions.

#### Scenario: Keymap wrapper function maps keys with description
- **WHEN** `jasper.map("n", "<leader>w", ":w<CR>", "Save file")` is called
- **THEN** a normal-mode keymap `<leader>w` SHALL be created with description "Save file"

#### Scenario: Mode-specific wrappers exist for common modes
- **WHEN** `jasper.nnoremap`, `jasper.inoremap`, `jasper.vnoremap`, `jasper.xnoremap` are called
- **THEN** each SHALL wrap `jasper.map` with the corresponding mode preset

#### Scenario: combine_lists merges two lists without duplicates
- **WHEN** `jasper.combine_lists({1, 2, 3}, {3, 4, 5})` is called
- **THEN** the result SHALL be `{1, 2, 3, 4, 5}` without duplicate `3`

#### Scenario: debounce delays function execution
- **WHEN** a debounced function is called multiple times within `100` ms
- **THEN** the function SHALL execute only once, `100` ms after the last call

#### Scenario: Entry point requires submodules
- **WHEN** `require("jasper")` is called
- **THEN** it SHALL load `jasper.utils`, `jasper.keymaps`, `jasper.lsp`, `jasper.telescope`, and `jasper.autocmds`
