## ADDED Requirements

### Requirement: BufWritePre formatter finds correct LSP client
The system SHALL use `vim.lsp.get_clients({ bufnr = args.buf })` in the `BufWritePre` autocmd instead of `args.data.client_id` to obtain the active LSP client for the buffer being saved.

#### Scenario: Formatter triggers on save with correct client
- **WHEN** saving a buffer that has an LSP client with formatting capability attached
- **THEN** the format-on-save autocmd SHALL invoke `vim.lsp.buf.format()` for that buffer

#### Scenario: Formatter does not error when no client is attached
- **WHEN** saving a buffer with no LSP client
- **THEN** the autocmd SHALL silently no-op without throwing an error

### Requirement: ts_ls formatting is disabled exactly once
The `configs/lspconfig.lua` SHALL disable `documentFormattingProvider` for `ts_ls` in exactly one place, using the `features` parameter of `jasper.server()`.

#### Scenario: No duplicate formatting disable
- **WHEN** inspecting `configs/lspconfig.lua` for `ts_ls` setup
- **THEN** `documentFormattingProvider = false` SHALL be set in exactly one location
