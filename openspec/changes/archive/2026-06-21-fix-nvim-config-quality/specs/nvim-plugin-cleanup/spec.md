## ADDED Requirements

### Requirement: Dead config files SHALL be removed or imported
Config files under `configs/` that are not imported by any other module SHALL be either removed or explicitly imported.

#### Scenario: Orphan configs are resolved
- **WHEN** inspecting `configs/` directory
- **THEN** files NOT referenced by any other Lua file SHALL be removed

### Requirement: Disabled plugins SHALL be cleaned up
Plugin specs with `enabled = false` SHALL be either enabled, have an explanatory comment, or be removed.

#### Scenario: Disabled plugins have rationale
- **WHEN** a plugin spec has `enabled = false`
- **THEN** it SHALL have a comment explaining why it is disabled (e.g., `-- WIP: evaluating`)

### Requirement: Dead code SHALL be removed
Commented-out code blocks and unused variables SHALL be removed from the codebase.

#### Scenario: Commented DAP mappings are removed
- **WHEN** `mappings.lua` is evaluated
- **THEN** the ~48 line commented DAP block SHALL be removed

#### Scenario: Unused nomap variable is removed
- **WHEN** `mappings.lua` is evaluated
- **THEN** `local nomap = vim.keymap.del` SHALL NOT exist (or SHALL be used)

### Requirement: Treesitter config SHALL be centralized
All `nvim-treesitter.configs.setup()` calls SHALL be unified in one location.

#### Scenario: Single treesitter setup call
- **WHEN** searching for `nvim-treesitter.configs.setup` across all `.lua` files
- **THEN** it SHALL be called in exactly one file

### Requirement: Deprecated plugin SHALL be replaced
The `jose-elias-alvarez/typescript.nvim` plugin SHALL be replaced with `pmizio/typescript-tools.nvim`.

#### Scenario: typescript-nvim replaced
- **WHEN** inspecting plugins under `plugins/spec/lang/`
- **THEN** `jose-elias-alvarez/typescript.nvim` SHALL NOT appear
- **AND** `pmizio/typescript-tools.nvim` SHALL be used as the replacement

### Requirement: `configs/overrides.lua` unused sections SHALL be removed
Sections in `overrides.lua` (ui.statusline, telescope, blankline) that are overridden by `chadrc.lua` SHALL be removed.

#### Scenario: Unused override sections removed
- **WHEN** `configs/overrides.lua` is evaluated
- **THEN** `M.ui.statusline`, `M.telescope`, and `M.blankline` SHALL NOT exist
