## MODIFIED Requirements

### Requirement: Enable editor extras
The system SHALL enable the following LazyVim editor extras: harpoon2, grug-far, edgy, diffview, neogit, undotree, trouble-ls.

#### Scenario: undotree extra may be disabled if built-in works
- **WHEN** nvim 0.12 built-in `:Undotree` is functional
- **THEN** the `undotree` LazyVim extra MAY be disabled
- **AND** the built-in `:Undotree` command SHALL work

#### Scenario: diffview extra remains active
- **WHEN** LazyVim loads
- **THEN** the `diffview` extra SHALL remain enabled
- **AND** `sindrets/diffview.nvim` SHALL be available
