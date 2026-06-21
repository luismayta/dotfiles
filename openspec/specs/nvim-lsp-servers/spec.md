# nvim-lsp-servers Specification

## Purpose
TBD - created by archiving change fix-nvim-config-quality. Update Purpose after archive.
## Requirements
### Requirement: LSP servers SHALL be configured exactly once
Each LSP server SHALL have exactly one `.setup()` call. No server SHALL appear in both the generic `servers` list and a dedicated config block.

#### Scenario: tsserver is removed from generic servers list
- **WHEN** `configs/lspconfig.lua` is evaluated
- **THEN** `"tsserver"` SHALL NOT be in the `servers` ipairs loop
- **AND** `tsserver` SHALL only be configured in its dedicated block

#### Scenario: Dedicated tsserver block disables formatting
- **WHEN** tsserver is configured in its dedicated block
- **THEN** `client.server_capabilities.documentFormattingProvider` SHALL be `false`
- **AND** `client.server_capabilities.documentRangeFormattingProvider` SHALL be `false`

### Requirement: tsserver SHALL be migrated to ts_ls
All references to `lspconfig.tsserver` SHALL be replaced with `lspconfig.ts_ls`.

#### Scenario: tsserver alias not used
- **WHEN** grep searches for `tsserver` in all `.lua` files under `data/lua/`
- **THEN** no matches SHALL be found (except possibly in comments)

### Requirement: null-ls references SHALL be migrated to none-ls or removed
The `require("null-ls")` call in `configs/lspconfig.lua` SHALL use `none-ls` if kept, or the null-ls formatting block SHALL be removed entirely in favor of conform.nvim.

#### Scenario: null-ls require is consistent
- **WHEN** `configs/lspconfig.lua` is evaluated
- **THEN** `require("null-ls")` SHALL NOT appear (use `none-ls` or remove)

### Requirement: typescript.lua SHALL have correct variable scope
The `plugins/spec/lang/typescript.lua` config function SHALL have `nvlsp` and `on_attach` correctly defined in its scope.

#### Scenario: nvlsp is available in config function
- **WHEN** the TypeScript plugin config function executes
- **THEN** `require("nvchad.configs.lspconfig")` SHALL be required locally
- **AND** no `nil` value errors SHALL occur for `nvlsp` or `on_attach`

### Requirement: on_attach SHALL NOT be duplicated in typescript.lua
The `lspconfig.tsserver.setup` call in `typescript.lua` SHALL have exactly one `on_attach` key.

#### Scenario: Single on_attach in setup
- **WHEN** `typescript.lua` lspconfig setup is evaluated
- **THEN** the setup table SHALL contain one `on_attach` entry
- **AND** formatting SHALL be disabled in that single entry

### Requirement: LSP servers SHALL be unified under one configuration strategy
The system SHALL use exactly one strategy for LSP server setup: either `mason-lspconfig` with `setup_handlers`, or manual `.setup()` calls in `lspconfig.lua`, not both.

#### Scenario: No duplicate server lists
- **WHEN** comparing `ensure_installed` across `mason.lua`, `mason-lspconfig.lua`, and `lspconfig.lua`
- **THEN** each server SHALL appear in at most one `ensure_installed` list

