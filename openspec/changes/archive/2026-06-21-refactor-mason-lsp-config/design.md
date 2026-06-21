## Context

The Neovim LSP ecosystem has evolved. With Neovim 0.12+, the native API (`vim.lsp.config()` + `vim.lsp.enable()`) provides a first-class way to define and enable LSP servers without external orchestrators like `mason-lspconfig.nvim`. The reference NvChad v2.5 config (`mgastonportillo/nvchad-config`) already uses this pattern exclusively.

Currently, our config has two overlapping paths:
1. `mason-lspconfig.nvim` with `ensure_installed` + a `vim.lsp.enable` loop in `mason.lua`
2. Native `vim.lsp.config()` + `vim.lsp.enable()` in `configs/lspconfig.lua`

This dual approach caused: Mason UI not rendering, confusion about where servers are defined, redundant `ensure_installed` lists, and unnecessary plugin dependencies.

## Goals / Non-Goals

**Goals:**
- Remove `mason-lspconfig.nvim` entirely — it's redundant with native API
- Simplify `mason.nvim` to only manage tool installations (install Mason packages, not LSP servers)
- Add proper `ui.border = "rounded"` to restore Mason UI rendering
- Migrate all servers from `mason-lspconfig`'s `ensure_installed` into `configs/lspconfig.lua` using native API
- Keep `mason-tool-installer.nvim` only for non-LSP tools (goimports, gofumpt)
- Regenerate `plugins/init.lua` to reflect removed plugins

**Non-Goals:**
- No changes to how LSP servers are configured per-project
- No changes to keymaps, autocommands, or diagnostics
- No migration of existing `configs/lspconfig.lua` server configurations
- No changes to the `mason-tool-installer.nvim` plugin or its ensure_installed list

## Decisions

### Decision: Remove `mason-lspconfig.nvim` entirely
- **Why**: With Neovim 0.12+'s native `vim.lsp.config()` + `vim.lsp.enable()`, `mason-lspconfig` offers nothing that the native API doesn't. The reference repo proves this pattern works cleanly.
- **Alternatives considered**: Keep `mason-lspconfig` but disable `automatic_installation` and use native APIs alongside it. Rejected because dual paths create confusion and maintenance burden.

### Decision: `mason.nvim` only manages tool installation
- **Why**: Mason's job is downloading LSP servers and tools. It should not decide which servers are configured. LSP config is a separate concern handled by `vim.lsp.config()`.
- **UI fix**: Adding `ui.border = "rounded"` in Mason opts restores the graphical Mason interface that broke.

### Decision: All servers use `vim.lsp.config()` + `vim.lsp.enable()`
- **Why**: This is the native Neovim 0.12+ API. Servers with custom config get `vim.lsp.config()`, simple servers get `vim.lsp.enable({...})`. No more lspconfig `setup()` calls for server registration.
- **Migration**: Servers that were only in `mason-lspconfig`'s `ensure_installed` (and not yet in `configs/lspconfig.lua`) get added as simple `vim.lsp.enable()` entries.

### Decision: Keep `mason-tool-installer.nvim`
- **Why**: Mason tools (goimports, gofumpt) are not LSP servers. `mason-tool-installer` handles them cleanly without polluting LSP config.

## Risks / Trade-offs

- **[Risk] Server not installed automatically**: Without `mason-lspconfig`'s `automatic_installation`, users must run `:Mason` to install servers manually, or we keep `mason-tool-installer` for LSP servers too.
  - **Mitigation**: Add all LSP server names to `mason-tool-installer.nvim`'s `ensure_installed` alongside the tools. This keeps auto-install working without `mason-lspconfig`.

- **[Risk] Breaking existing LSP configs**: Removing `mason-lspconfig` could affect servers with complex setup requirements.
  - **Mitigation**: All servers that were in `configs/lspconfig.lua` already use native API and are unaffected. Servers only in `ensure_installed` will be migrated explicitly.

- **[Risk] Mason UI still broken**: The UI issue might not be solely due to missing `ui.border`.
  - **Mitigation**: Check Mason logs (`:MasonLog`) after change. If still broken, investigate Mason version compatibility.

- **[Risk] `mason-tool-installer` overlap**: Some tools (like `gopls`) could end up in both `mason-tool-installer` and `vim.lsp.enable`.
  - **Mitigation**: `mason-tool-installer` handles installation; `vim.lsp.enable` handles config. They're complementary, not conflicting.
