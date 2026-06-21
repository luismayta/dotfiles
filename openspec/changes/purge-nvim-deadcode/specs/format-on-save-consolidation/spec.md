## ADDED Requirements

### Requirement: Remove duplicate BufWritePre format-on-save from jasper/lsp.lua
The system SHALL remove the BufWritePre autocmd creation from `jasper/lsp.lua` to eliminate duplicate formatting on save. The global autocmd in `jasper/autocmds.lua` SHALL remain as the single source.

#### Scenario: Confirm jasper/autocmds.lua handles format-on-save
- **WHEN** reviewing `jasper/autocmds.lua`
- **THEN** it MUST have a BufWritePre autocmd that calls `vim.lsp.buf.format()`

#### Scenario: Remove format-on-save from jasper/lsp.lua
- **WHEN** the removal runs
- **THEN** the BufWritePre autocmd creation in `jasper/lsp.lua` (lines ~67-74) SHALL be deleted

#### Scenario: Format-on-save still works
- **WHEN** a Lua file is saved with active LSP client
- **THEN** it SHALL be formatted exactly once

#### Scenario: No load errors
- **WHEN** nvim starts with the consolidated autocmd
- **THEN** `nvim --headless -c "qa"` MUST exit with code 0
