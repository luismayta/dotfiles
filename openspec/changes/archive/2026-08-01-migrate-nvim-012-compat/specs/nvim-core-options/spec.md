## MODIFIED Requirements

### Requirement: Neovim core options SHALL be applied at startup
The system SHALL apply all options defined in `options.lua` to `vim.opt` during Neovim startup. Options MUST include: encoding, clipboard, fold settings, scrolloff, backspace, relativenumber, wrap/linebreak, indentation (tabstop, shiftwidth, expandtab, autoindent), cursorline, ignorecase, updatetime, lazyredraw, iskeyword, path, and textwidth. Options that are now defaults in nvim 0.12 (termguicolors, softtabstop, breakindent, inccommand) SHALL NOT be explicitly set.

#### Scenario: Options are applied on startup
- **WHEN** Neovim starts
- **THEN** the loop `for k, v in pairs(opt) do vim.opt[k] = v end` SHALL execute
- **AND** `vim.opt.encoding` SHALL be `"utf-8"`
- **AND** `vim.opt.clipboard` SHALL be `"unnamedplus"`
- **AND** `vim.opt.tabstop` SHALL be `2`
- **AND** `vim.opt.textwidth` SHALL be `80`

#### Scenario: Redundant 0.12 defaults are not set
- **WHEN** `options.lua` is evaluated
- **THEN** `termguicolors` SHALL NOT appear in the opt table
- **AND** `softtabstop` SHALL NOT appear in the opt table
- **AND** `breakindent` SHALL NOT appear in the opt table
- **AND** `inccommand` SHALL NOT appear in the opt table
