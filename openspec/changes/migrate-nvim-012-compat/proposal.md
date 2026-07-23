## Why

Neovim 0.12 introduces breaking API changes (removed `vim.diagnostic.disable()`, renamed `vim.diff` → `vim.text.diff`, `vim.lsp.semantic_tokens` → `enable()`) and powerful new built-ins (`vim._core.ui2`, `vim.pack`, `:Undotree`, `:DiffTool`, `vim.lsp.completion.enable()`, `vim.lsp.inlayhints`). The current LazyVim v8 config with 57+ plugins has no direct deprecated API usage in user config files, but several plugins (lsp-inlayhints.nvim, undotree.nvim, diffview.nvim) can now be replaced by built-in alternatives, reducing dependency count and improving startup time. Migrating now prevents breakage when upgrading nvim and unlocks native features.

## What Changes

- **BREAKING**: Replace `vim.diagnostic.disable()` calls with `vim.diagnostic.enable(false)` (if any exist in plugins or LazyVim internals)
- **BREAKING**: Rename `vim.diff` → `vim.text.diff` in any custom diff code
- **BREAKING**: Update `vim.lsp.semantic_tokens` `start()/stop()` → `enable()`
- Remove `lvimuser/lsp-inlayhints.nvim` plugin dependency; migrate to `vim.lsp.inlayhints` built-in
- Evaluate replacing `mbbill/undotree` with built-in `:Undotree`
- Evaluate replacing `sindrets/diffview.nvim` with built-in `:DiffTool`
- Evaluate replacing `nvimtools/noice.nvim` with `vim._core.ui2` (experimental)
- Evaluate replacing `hrsh7th/nvim-cmp` with `vim.lsp.completion.enable()` (experimental)
- Update `options.lua` to remove options now default in 0.12 (`termguicolors`, `softtabstop`, `breakindent`, `inccommand`) and add `textwidth = 80`
- Simplify LSP setup using `vim.lsp.config` / `vim.lsp.enable` if lspconfig supports it

## Capabilities

### New Capabilities
- `nvim-012-api-migration`: Migrate deprecated nvim 0.12 APIs (vim.diagnostic, vim.diff, vim.lsp.semantic_tokens) to their replacements
- `nvim-012-builtins-adoption`: Replace plugin-based features with nvim 0.12 built-ins (vim.lsp.inlayhints, :Undotree, :DiffTool, vim._core.ui2, vim.lsp.completion)

### Modified Capabilities
- `nvim-core-options`: Update defaults for nvim 0.12 (remove redundant options, add textwidth)
- `nvim-lsp-servers`: Simplify LSP setup using new vim.lsp.config/vim.lsp.enable APIs; migrate inlay hints to built-in
- `nvim-plugin-cleanup`: Update plugin removal list for nvim 0.12 built-in replacements
- `lazyvim-extras`: Update diffview/undotree extras if replaced by built-ins

## Impact

- **Config files**: `options.lua`, `keymaps.lua`, `autocmds.lua`, `lazy.lua`, `plugins/init.lua`, `plugins/lang/rust.lua`, `plugins/lang/typescript.lua`, `plugins/tools/diffview.lua`, `plugins/ui/ui.lua`
- **Plugins affected**: lsp-inlayhints.nvim (remove), undotree (evaluate remove), diffview.nvim (evaluate remove), noice.nvim (evaluate remove), nvim-cmp (evaluate remove)
- **Dependencies**: LazyVim v8, mason.nvim, mason-lspconfig.nvim, lspconfig.nvim
- **Risk**: Low for API migration (no direct deprecated usage found). Medium for built-in adoption (requires testing each replacement)
