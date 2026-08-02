## ADDED Requirements

### Requirement: lsp-inlayhints.nvim SHALL be replaced with vim.lsp.inlayhints
The `lvimuser/lsp-inlayhints.nvim` plugin dependency SHALL be removed from `plugins/lang/rust.lua`. Inlay hints SHALL be configured using the built-in `vim.lsp.inlayhints` API.

#### Scenario: lsp-inlayhints plugin removed
- **WHEN** grepping for `lsp-inlayhints` across all `.lua` files in `data/lua/`
- **THEN** no matches SHALL be found

#### Scenario: Built-in inlay hints enabled
- **WHEN** Neovim starts with a Rust file
- **THEN** `vim.lsp.inlayhints.enable()` SHALL be called for the buffer
- **AND** inlay hints SHALL be rendered by the built-in system

#### Scenario: Toggle inlay hints keymap exists
- **WHEN** user presses the configured inlay hints toggle keymap
- **THEN** `vim.lsp.inlayhints.enable()` SHALL toggle on/off for the current buffer

### Requirement: undotree.nvim SHALL be replaced with built-in :Undotree
The `mbbill/undotree` plugin spec in `plugins/ui/ui.lua` SHALL be replaced by the built-in `:Undotree` command available in nvim 0.12.

#### Scenario: undotree plugin removed
- **WHEN** grepping for `mbbill/undotree` across all `.lua` files in `data/lua/`
- **THEN** no matches SHALL be found

#### Scenario: Built-in undotree works
- **WHEN** user runs `:Undotree`
- **THEN** the undo visualization panel SHALL open

### Requirement: diffview.nvim SHALL be kept (no replacement yet)
The `sindrets/diffview.nvim` plugin SHALL remain in the config. The built-in `:DiffTool` does not fully replace DiffviewOpen/DiffviewFileHistory workflows.

#### Scenario: diffview plugin retained
- **WHEN** grepping for `sindrets/diffview` across all `.lua` files in `data/lua/`
- **THEN** at least one match SHALL be found

### Requirement: noice.nvim SHALL be kept (no replacement yet)
The `nvimtools/noice.nvim` plugin (LazyVim default) SHALL remain. `vim._core.ui2` is experimental and may break LazyVim's notification system.

#### Scenario: noice remains as LazyVim default
- **WHEN** LazyVim loads
- **THEN** noice.nvim SHALL handle notifications (unless user explicitly disables it)

### Requirement: nvim-cmp SHALL be kept (no replacement yet)
The `hrsh7th/nvim-cmp` plugin (LazyVim default) SHALL remain. `vim.lsp.completion.enable()` lacks snippet expansion and source diversity needed for full functionality.

#### Scenario: nvim-cmp remains as LazyVim default
- **WHEN** LazyVim loads
- **THEN** nvim-cmp SHALL handle completion

### Requirement: options.lua SHALL be simplified for nvim 0.12 defaults
Options that are now defaults in nvim 0.12 SHALL be removed from `options.lua` to reduce redundancy. `textwidth = 80` SHALL be added for the new `formatoptions` `j` default.

#### Scenario: Redundant options removed
- **WHEN** `options.lua` is evaluated
- **THEN** `termguicolors` SHALL NOT be explicitly set (now default)
- **AND** `softtabstop` SHALL NOT be explicitly set to `-1` (now default)
- **AND** `breakindent` SHALL NOT be explicitly set to `true` (now default)
- **AND** `inccommand` SHALL NOT be explicitly set to `"nosplit"` (already default in 0.11)

#### Scenario: textwidth added
- **WHEN** `options.lua` is evaluated
- **THEN** `vim.opt.textwidth` SHALL be `80`
