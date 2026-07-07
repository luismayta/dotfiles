## ADDED Requirements

### Requirement: Fast fold method for large files
The system SHALL use `foldmethod=indent` with `foldlevel=99` as the default folding strategy, replacing treesitter-based fold expression, to ensure fast buffer loading and editing in files of any size.

#### Scenario: Opening a large file
- **WHEN** a file with >1000 lines is opened
- **THEN** the buffer loads without perceptible delay caused by fold computation
- **AND** no folds are visible (all content expanded)

#### Scenario: Editing in a large file
- **WHEN** the user inserts or deletes text in a file >500 lines
- **THEN** there is no fold-recalculation delay after each change

### Requirement: On-demand treesitter folding
The system SHALL provide a command `:FoldTS` to enable treesitter-based folding on-demand, allowing the user to access semantic folding when needed without paying the cost by default.

#### Scenario: User requests treesitter folding
- **WHEN** the user runs `:FoldTS`
- **THEN** foldmethod is set to `expr` and foldexpr to `v:lua.vim.treesitter.foldexpr()`
- **AND** folds are immediately recalculated using treesitter

#### Scenario: User resets to fast folding
- **WHEN** the user runs `:FoldTS` again (toggle)
- **THEN** foldmethod returns to `indent` with `foldlevel=99`
