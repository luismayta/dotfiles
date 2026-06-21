## Why

The current Mason + LSP configuration has two overlapping strategies — `mason-lspconfig.nvim` with `ensure_installed` plus a `vim.lsp.enable` loop, and native `vim.lsp.config()` in `configs/lspconfig.lua` — causing Mason UI issues, duplicated server lists, and unnecessary complexity. With Neovim 0.12+, the native LSP config API (`vim.lsp.config()` + `vim.lsp.enable()`) is the recommended approach, making `mason-lspconfig.nvim` redundant.

## What Changes

- **Remove `williamboman/mason-lspconfig.nvim`** from the plugin spec entirely — its `ensure_installed` + `automatic_installation` + `cmd` combo is no longer needed.
- **Simplify `mason.nvim`** — strip unnecessary complexity, add `ui.border = "rounded"` for proper Mason UI rendering, and remove server management from Mason.
- **Unify all LSP server definitions** in `configs/lspconfig.lua` using only `vim.lsp.config()` + `vim.lsp.enable()` — the native Neovim 0.12+ API.
- **Keep `mason-tool-installer.nvim`** for non-LSP tools (`goimports`, `gofumpt`), but clean up its config if needed.
- **Regenerate `plugins/init.lua`** via `task build` so the removed plugins are no longer imported.

## Capabilities

### New Capabilities

None — this is a refactor of existing capabilities, no new functionality is introduced.

### Modified Capabilities

- `nvim-mason-setup`: Mason no longer manages LSP servers — only handles tool installation. The `mason-lspconfig` plugin is removed entirely. Mason UI config is simplified with proper border settings.
- `nvim-lsp-servers`: All LSP servers are now configured exclusively via `vim.lsp.config()` + `vim.lsp.enable()` in `configs/lspconfig.lua`. The redundant `mason-lspconfig` `ensure_installed` + `vim.lsp.enable` loop is eliminated. Servers that were in the loop but absent from `configs/lspconfig.lua` need to be added there.

## Impact

- `plugins/spec/lsp/mason.lua` — rewritten: remove mason-lspconfig block, simplify mason.nvim
- `plugins/spec/lsp/mason-tools.lua` — stays but may need minor cleanup
- `configs/lspconfig.lua` — expanded to include servers previously only in mason-lspconfig's `ensure_installed`
- `plugins/init.lua` — regenerated via `task build`, drops the removed mason-lspconfig import
- Mason UI will render correctly again due to proper `ui.border` setting
- No breaking changes to user workflow — `:Mason` and `:LspInfo` still work
