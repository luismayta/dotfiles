## 1. Orphaned Config Cleanup

- [ ] 1.1 Delete `zsh/modules/nvim/data/lua/configs/mason.lua`
- [ ] 1.2 Delete `zsh/modules/nvim/data/lua/configs/neoscroll.lua`
- [ ] 1.3 Delete `zsh/modules/nvim/data/lua/configs/treesitter-context.lua`
- [ ] 1.4 Delete `zsh/modules/nvim/data/lua/configs/hop.lua`
- [ ] 1.5 Delete `zsh/modules/nvim/data/lua/configs/tabout.lua`
- [ ] 1.6 Delete `zsh/modules/nvim/data/lua/configs/illuminate.lua`
- [ ] 1.7 Delete `zsh/modules/nvim/data/lua/configs/visual-multi.lua`

> Nota: `configs/scrollview.lua` NO se elimina — está referenciado en `spec/ui/ui.lua:37`

## 2. Chadrc Dead Code Purge

- [ ] 2.1 Remove `vim.cmd [[Lspsaga hover_doc]]` mapping from `chadrc.lua`
- [ ] 2.2 Remove `vim.cmd [[Lspsaga code_action]]` mapping from `chadrc.lua`
- [ ] 2.3 Remove `vim.cmd [[Lspsaga lsp_finder]]` mapping from `chadrc.lua`
- [ ] 2.4 Remove `vim.cmd [[Lspsaga show_line_diagnostics]]` mapping from `chadrc.lua`
- [ ] 2.5 Remove `vim.cmd [[Lspsaga show_cursor_diagnostics]]` mapping from `chadrc.lua`
- [ ] 2.6 Update `require("nvchad_ui.renamer")` to `require("nvchad.ui.renamer")` in `chadrc.lua`

## 3. Broken Mason Setup Fix

- [ ] 3.1 Change `require("configs.mason-lspconfig")` to `require("configs.mason")` in `spec/lsp/mason.lua`

## 4. Jasper Keymaps Single Source of Truth

- [ ] 4.1 Remove duplicate `setup_keymaps` function from `jasper/lsp.lua` (lines 7-24)
- [ ] 4.2 Replace the `setup_keymaps(bufnr)` call in `jasper/lsp.lua`'s `on_attach` with `require("jasper.keymaps").lsp(bufnr)`

## 5. Keymap Duplication Resolution

- [ ] 5.1 Remove telescope mappings from `spec/ui/ui.lua` (superseded by jasper.telescope wrappers in `mappings.lua`)
- [ ] 5.2 Remove `<C-Up>` and `<C-Down>` colorify mappings from `mappings.lua`

## 6. Format-on-Save Consolidation

- [ ] 6.1 Remove duplicate BufWritePre autocmd creation from `jasper/lsp.lua`
- [ ] 6.2 Confirm `jasper/autocmds.lua` still has a BufWritePre format handler

## 7. Nvim Zsh Config Fixes

- [ ] 7.1 Fix `NVIM_FILE_SETTINGS` path in `config/base.zsh` from `lua/config/options.lua` to `lua/options.lua`
- [ ] 7.2 Remove `NVIM_ROOT_PATH` duplicate variable from `config/base.zsh`

## 8. Verification

- [ ] 8.1 Run `luac -p` on all remaining Lua files in `data/`
- [ ] 8.2 Run `nvim --headless -c "qa"` to verify clean startup
- [ ] 8.3 Run `task build` to regenerate plugin imports
