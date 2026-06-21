# nvim-core-options Specification

## Purpose
TBD - created by archiving change fix-nvim-config-quality. Update Purpose after archive.
## Requirements
### Requirement: Neovim core options SHALL be applied at startup
The system SHALL apply all options defined in `options.lua` to `vim.opt` during Neovim startup. Options MUST include: encoding, clipboard, fold settings, scrolloff, backspace, termguicolors, relativenumber, wrap/linebreak, indentation (tabstop, shiftwidth, expandtab, autoindent), cursorline, inccommand, ignorecase, updatetime, lazyredraw, iskeyword, and path.

#### Scenario: Options are applied on startup
- **WHEN** Neovim starts
- **THEN** the loop `for k, v in pairs(opt) do vim.opt[k] = v end` SHALL execute
- **AND** `vim.opt.encoding` SHALL be `"utf-8"`
- **AND** `vim.opt.clipboard` SHALL be `"unnamedplus"`
- **AND** `vim.opt.tabstop` SHALL be `2`

### Requirement: Global variables SHALL be set at startup
The system SHALL apply all global variables defined in `options.lua` to `vim.g` during Neovim startup.

#### Scenario: Global variables are set
- **WHEN** Neovim starts
- **THEN** the loop `for k, v in pairs(g) do vim.g[k] = v end` SHALL execute
- **AND** `vim.g.dap_virtual_text` SHALL be `true`

### Requirement: Config file SHALL parse without runtime errors
The `options.lua` file SHALL load without Lua errors.

#### Scenario: File loads successfully
- **WHEN** Neovim evaluates `options.lua`
- **THEN** no Lua error SHALL be raised
- **AND** both `opt` and `g` tables SHALL be fully iterated

