## ADDED Requirements

### Requirement: LSP servers missing from configs/lspconfig.lua SHALL be added

Servers that were only listed in `mason-lspconfig`'s `ensure_installed` (not yet in `configs/lspconfig.lua`) SHALL be added there using `vim.lsp.enable()` with no extra config.

Affected servers from current `ensure_installed`: `ansiblels`, `tflint`, `bashls`, `ruff`, `texlab`, `marksman`, `solidity`, `taplo`, `sqls`, `sqlls`, `intelephense`.

#### Scenario: All servers from previous ensure_installed are present
- **WHEN** `configs/lspconfig.lua` is evaluated
- **THEN** each server from the previous mason-lspconfig `ensure_installed` list SHALL have a corresponding `vim.lsp.enable()` call
- **AND** no `require("mason-lspconfig")` call SHALL exist

## MODIFIED Requirements

### Requirement: LSP servers SHALL be configured exactly once

Each LSP server SHALL have exactly one configuration definition. No server SHALL appear in both an `ensure_installed` list and a `vim.lsp.config()` block, or in multiple `ensure_installed` lists across files.

#### Scenario: Servers not in mason-lspconfig ensure_installed
- **WHEN** `configs/lspconfig.lua` is evaluated
- **THEN** all LSP server configurations SHALL be defined via `vim.lsp.config()` or `vim.lsp.enable()`
- **AND** there SHALL be no `ensure_installed` list for LSP servers outside of `configs/lspconfig.lua`

### Requirement: LSP servers SHALL be unified under one configuration strategy

The system SHALL use exactly one strategy for LSP server setup: the native Neovim 0.12+ API (`vim.lsp.config()` + `vim.lsp.enable()`) in `configs/lspconfig.lua`. The `mason-lspconfig` plugin SHALL NOT be present.

#### Scenario: No mason-lspconfig plugin spec
- **WHEN** searching for `"williamboman/mason-lspconfig.nvim"` in plugin spec files
- **THEN** no matches SHALL be found

#### Scenario: All LSP servers defined in configs/lspconfig.lua
- **WHEN** grepping for `vim.lsp.enable` in all `.lua` files
- **THEN** `vim.lsp.enable` calls SHALL only appear in `configs/lspconfig.lua`
