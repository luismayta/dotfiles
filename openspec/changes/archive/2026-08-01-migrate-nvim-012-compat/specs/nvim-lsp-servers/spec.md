## MODIFIED Requirements

### Requirement: LSP servers SHALL be configured exactly once
Each LSP server SHALL have exactly one configuration. No server SHALL appear in both a generic `servers` list and a dedicated config block. LSP setup SHOULD use `vim.lsp.config` / `vim.lsp.enable` if lspconfig supports it, or maintain mason-lspconfig setup_handlers.

#### Scenario: tsserver is removed from generic servers list
- **WHEN** `configs/lspconfig.lua` is evaluated
- **THEN** `"tsserver"` SHALL NOT be in the `servers` ipairs loop
- **AND** `tsserver` SHALL only be configured in its dedicated block

#### Scenario: Inlay hints use built-in API
- **WHEN** LSP servers attach to a buffer
- **THEN** `vim.lsp.inlayhints.enable()` SHALL be called for the buffer
- **AND** `lvimuser/lsp-inlayhints.nvim` SHALL NOT be required

### Requirement: typescript.lua SHALL have correct variable scope
The TypeScript plugin config function SHALL use `vim.lsp.protocol.make_client_capabilities()` correctly and not reference undefined variables.

#### Scenario: nvlsp is available in config function
- **WHEN** the TypeScript plugin config function executes
- **THEN** no `nil` value errors SHALL occur

### Requirement: LSP servers SHALL be unified under one configuration strategy
The system SHALL use exactly one strategy for LSP server setup: either `mason-lspconfig` with `setup_handlers`, or manual `.setup()` calls, not both.

#### Scenario: No duplicate server lists
- **WHEN** comparing `ensure_installed` across mason config files
- **THEN** each server SHALL appear in at most one `ensure_installed` list
