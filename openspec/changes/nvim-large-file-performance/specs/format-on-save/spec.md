## ADDED Requirements

### Requirement: Single format-on-save mechanism
The system SHALL format files on save using only `conform.nvim`, with no duplicate or competing format-on-save autocmd.

#### Scenario: Saving a file
- **WHEN** the user saves a file (`:w`)
- **THEN** `conform.nvim` formats the buffer using the formatter configured for that filetype
- **AND** no LSP-client formatting is initiated by a separate BufWritePre autocmd
- **AND** the file is saved only once (no double format)

#### Scenario: LSP fallback formatting
- **WHEN** no filetype-specific formatter is configured in conform
- **THEN** conform falls back to LSP formatting via `lsp_fallback = true`
- **AND** the result is identical to the previous behavior of the BufWritePre autocmd

### Requirement: Removed redundant BufWritePre autocmd
The autocmd in `autocmds.lua` that iterates all LSP clients and calls `vim.lsp.buf.format` on `BufWritePre` SHALL be removed.

#### Scenario: autocmds.lua after change
- **WHEN** inspecting `autocmds.lua`
- **THEN** there is NO BufWritePre autocmd that calls `vim.lsp.buf.format`
- **AND** conform.nvim is the sole mechanism for format-on-save
