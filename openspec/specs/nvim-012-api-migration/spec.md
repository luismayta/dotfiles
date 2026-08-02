# nvim-012-api-migration

## Purpose

Migrate the nvim config's API calls to nvim 0.12 signatures: replace deprecated `vim.diagnostic` functions, swap `vim.diff` for `vim.text.diff`, use the new `vim.lsp.semantic_tokens.enable()` API, and handle the `activePreselectIndex` field rename in signature help.

## Requirements

### Requirement: vim.diagnostic API calls SHALL use nvim 0.12 signatures
All `vim.diagnostic` calls in the config MUST use nvim 0.12 function signatures. `vim.diagnostic.disable()` SHALL be replaced with `vim.diagnostic.enable(false)`. `vim.diagnostic.is_disabled()` SHALL be replaced with `not vim.diagnostic.is_enabled()`.

#### Scenario: No deprecated diagnostic disable calls
- **WHEN** grepping for `vim.diagnostic.disable` across all `.lua` files in `data/lua/`
- **THEN** no matches SHALL be found

#### Scenario: No deprecated diagnostic is_disabled calls
- **WHEN** grepping for `vim.diagnostic.is_disabled` across all `.lua` files in `data/lua/`
- **THEN** no matches SHALL be found

#### Scenario: vim.diagnostic.enable uses new signature
- **WHEN** `vim.diagnostic.enable` is called
- **THEN** it SHALL use the `enable(bufnr, opts?)` signature, not the legacy `enable(bool)` form

### Requirement: vim.diff SHALL be replaced with vim.text.diff
All calls to `vim.diff` SHALL be replaced with `vim.text.diff`. If no direct calls exist in user config, this requirement is satisfied.

#### Scenario: No vim.diff calls in user config
- **WHEN** grepping for `vim.diff` across all `.lua` files in `data/lua/`
- **THEN** no matches SHALL be found (excluding comments)

### Requirement: vim.lsp.semantic_tokens SHALL use enable() API
All `vim.lsp.semantic_tokens.start()` and `vim.lsp.semantic_tokens.stop()` calls SHALL be replaced with `vim.lsp.semantic_tokens.enable()`. If no direct calls exist in user config, this requirement is satisfied.

#### Scenario: No deprecated semantic_tokens start/stop calls
- **WHEN** grepping for `semantic_tokens.start` and `semantic_tokens.stop` across all `.lua` files in `data/lua/`
- **THEN** no matches SHALL be found

### Requirement: vim.lsp.util.convert_signature_help_to_markdown_lines SHALL handle activePreselectIndex
If the config calls `vim.lsp.util.convert_signature_help_to_markdown_lines()`, it SHALL handle the `activePreselectIndex` field (renamed from `activeParameter` in 0.12).

#### Scenario: Signature help uses correct field name
- **WHEN** `vim.lsp.util.convert_signature_help_to_markdown_lines` is called
- **THEN** it SHALL reference `activePreselectIndex` if accessing the active parameter
