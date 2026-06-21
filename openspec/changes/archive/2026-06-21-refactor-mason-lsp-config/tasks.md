## 1. Rewrite mason.lua — remove mason-lspconfig, simplify Mason

- [x] 1.1 Remove `"williamboman/mason-lspconfig.nvim"` plugin entry from `mason.lua`
- [x] 1.2 Simplify `mason.nvim` config: add `ui.border = "rounded"`, remove server management logic
- [x] 1.3 Remove the `vim.lsp.enable` loop and `ensure_installed` list for LSP servers from `mason.lua`

## 2. Migrate servers to configs/lspconfig.lua

- [x] 2.1 Add `vim.lsp.enable()` calls for servers previously only in mason-lspconfig's `ensure_installed`: `ansiblels`, `tflint`, `bashls`, `ruff`, `texlab`, `marksman`, `solidity`, `taplo`, `sqls`, `sqlls`, `intelephense`
- [x] 2.2 Ensure no duplicate `vim.lsp.enable()` calls exist in `configs/lspconfig.lua`

## 3. Update mason-tools.lua to handle LSP server installation

- [x] 3.1 Add all LSP server names (from old `ensure_installed`) to `mason-tool-installer`'s `ensure_installed` to preserve automatic installation
- [x] 3.2 Keep existing `goimports` and `gofumpt` entries unchanged

## 4. Regenerate plugins/init.lua

- [x] 4.1 Run `task build` to regenerate `plugins/init.lua` with the updated plugin specs

## 5. Verify

- [x] 5.1 Run `lsp_diagnostics` on all modified `.lua` files
- [x] 5.2 Open Neovim and confirm `:Mason` UI renders with rounded borders
- [ ] 5.3 Open Neovim and confirm `:LspInfo` shows enabled servers — **note**: `:LspInfo` removed in Neovim 0.12.x (upstream change, not related to this refactor). Use `vim.lsp.get_clients()` instead.
- [ ] 5.4 Open a `.go` file and confirm `gopls` attaches — requires GUI test (headless confirmed `vim.lsp.enable('gopls')` OK)
- [ ] 5.5 Open a `.py` file and confirm `pyright` attaches — requires GUI test
- [ ] 5.6 Check Mason logs (`:MasonLog`) for errors — requires GUI test
