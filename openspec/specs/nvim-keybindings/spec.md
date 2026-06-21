# nvim-keybindings Specification

## Purpose
TBD - created by archiving change fix-nvim-config-quality. Update Purpose after archive.
## Requirements
### Requirement: All key mappings SHALL be unique per mode
No two mappings in the same mode SHALL share the same key sequence. Duplicate mappings SHALL be resolved so each key does exactly one action.

#### Scenario: `<leader>j` is not duplicated
- **WHEN** `mappings.lua` is evaluated
- **THEN** `<leader>j` SHALL appear exactly once in normal mode mappings
- **AND** the surviving `<leader>j` SHALL map to `:FocusSplitDown<CR>`

#### Scenario: `<leader>J` is used for split up
- **WHEN** `mappings.lua` is evaluated
- **THEN** `<leader>J` SHALL map to split up or FocusSplitUp (uppercase J)

### Requirement: Conflicting mappings across files SHALL be resolved
When the same key sequence is mapped in multiple files, the behavior SHALL be consistent or unified.

#### Scenario: `<leader>f` has consistent behavior
- **WHEN** both `chadrc.lua` and `configs/lspconfig.lua` define `<leader>f`
- **THEN** the mapping SHALL be consistent (format or diagnostic, not both)

#### Scenario: `<leader>l` has unique mapping
- **WHEN** `mappings.lua` is evaluated
- **THEN** `<leader>l` SHALL NOT duplicate `<leader>h`
- **AND** `<leader>l` SHALL map to a unique action

#### Scenario: `<leader>fc` has single definition
- **WHEN** comparing `mappings.lua` and `plugins/spec/ui/ui.lua`
- **THEN** `<leader>fc` SHALL be mapped in only one file

### Requirement: Deprecated API calls SHALL be updated
Commands using deprecated Trouble v2 API SHALL be updated to Trouble v3 syntax.

#### Scenario: Trouble commands use v3 API
- **WHEN** `mappings.lua` is evaluated
- **THEN** `TroubleToggle` SHALL NOT appear
- **AND** `Trouble diagnostics toggle` SHALL be used instead

