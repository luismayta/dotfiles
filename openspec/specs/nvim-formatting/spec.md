# nvim-formatting Specification

## Purpose
TBD - created by archiving change fix-nvim-config-quality. Update Purpose after archive.
## Requirements
### Requirement: Code formatting SHALL be consolidated in conform.nvim
All code formatting SHALL be handled by conform.nvim. No other formatting system (null-ls, none-ls, or manual LSP formatting) SHALL be active for formatting.

#### Scenario: conform.nvim is the primary formatter
- **WHEN** Neovim saves a file
- **THEN** conform.nvim SHALL handle formatting
- **AND** no other formatting autocmd SHALL be active

#### Scenario: Go formatters use conform
- **WHEN** Go files are formatted
- **THEN** `gofmt` SHALL be configured via conform.nvim `formatters_by_ft`
- **AND** none-ls SHALL NOT handle Go formatting

### Requirement: null-ls/none-ls formatting SHALL be removed
If null-ls or none-ls is used only for formatting, those configurations SHALL be removed and replaced by conform.nvim.

#### Scenario: null-ls formatting block is removed
- **WHEN** `configs/lspconfig.lua` is evaluated
- **THEN** the `null_ls.setup()` block SHALL NOT contain formatting sources
- **AND** `configs/null-ls.lua` SHALL be removed if it only contains formatting

### Requirement: `<leader>fm` SHALL be unified
The format mapping `<leader>fm` SHALL be defined in exactly one place.

#### Scenario: `<leader>fm` has single source
- **WHEN** grep searches for `<leader>fm` mappings
- **THEN** it SHALL appear in exactly one file

