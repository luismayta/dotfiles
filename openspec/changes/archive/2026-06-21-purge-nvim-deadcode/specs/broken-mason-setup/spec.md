## ADDED Requirements

### Requirement: Fix broken require in spec/lsp/mason.lua
The system SHALL fix the broken `require("configs.mason-lspconfig")` call in `spec/lsp/mason.lua` by routing it to the existing `configs.mason` instead.

#### Scenario: Fix require path
- **WHEN** the mason setup spec loads
- **THEN** it SHALL `require("configs.mason")` instead of `require("configs.mason-lspconfig")`

#### Scenario: ensure_installed list is preserved
- **WHEN** the require path is fixed
- **THEN** the `ensure_installed` list from `configs/mason.lua` SHALL still be loaded and applied

#### Scenario: No load errors
- **WHEN** nvim starts with the fixed require
- **THEN** `nvim --headless -c "lua require('plugins.spec.lsp.mason')" -c "qa"` MUST exit with code 0
