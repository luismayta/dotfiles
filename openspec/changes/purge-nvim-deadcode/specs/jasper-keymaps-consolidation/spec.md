## ADDED Requirements

### Requirement: Consolidate LSP keymaps into single source of truth
The system SHALL make `jasper/keymaps.lua` the single source of truth for LSP buffer keymaps, removing the duplicate `setup_keymaps` function from `jasper/lsp.lua` and delegating to `keymaps.lua` instead.

#### Scenario: Confirm keymaps.lua defines M.lsp(bufnr)
- **WHEN** inspecting `jasper/keymaps.lua`
- **THEN** it SHALL export `M.lsp = function(bufnr)` with the LSP mappings (gd, gD, gr, gi, K, gK, \<leader\>rn, \<leader\>ca, \<leader\>fm)

#### Scenario: Remove duplicate setup_keymaps from lsp.lua
- **WHEN** inspecting `jasper/lsp.lua`
- **THEN** the `setup_keymaps` function definition (lines 7–24) SHALL be removed

#### Scenario: Delegate to keymaps.lua from lsp.lua
- **WHEN** inspecting `jasper/lsp.lua`'s `on_attach`
- **THEN** `setup_keymaps(bufnr)` SHALL be replaced with `require("jasper.keymaps").lsp(bufnr)`

#### Scenario: Keep require in jasper/init.lua
- **WHEN** inspecting `jasper/init.lua`
- **THEN** `keymaps = require("jasper.keymaps")` SHALL remain (keymaps.lua is the source of truth)

#### Scenario: No load errors after refactor
- **WHEN** nvim starts after the change
- **THEN** `nvim --headless -c "qa"` MUST exit with code 0

#### Scenario: LSP keymaps still work per-buffer
- **WHEN** an LSP server attaches to a buffer
- **THEN** the keymaps `gd`, `gD`, `gr`, `gi`, `K`, `gK`, `<leader>rn`, `<leader>ca`, `<leader>fm` SHALL be available in that buffer
