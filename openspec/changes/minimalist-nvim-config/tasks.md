## 1. Core Setup

- [x] 1.1 Create `lua/core/init.lua` that requires options and keymaps
- [x] 1.2 Create `lua/core/options.lua` with essential nvim options (from reference: termguicolors, line numbers, indentation, search, splits, clipboard, yank highlight)
- [x] 1.3 Create `lua/core/keymaps.lua` with leader key, visual movement, centered scrolling, window management, utility keymaps
- [x] 1.4 Update `init.lua` to require `core` instead of LazyVim defaults

## 2. Plugin Structure Migration

- [x] 2.1 Create flat `lua/plugins/` directory structure
- [x] 2.2 Create `lua/plugins/lazy.lua` (lazy.nvim bootstrap + setup with `{ import = "plugins" }`)
- [x] 2.3 Create `lua/plugins/catppuccin.lua` (migrate from `plugins/ui/catppuccin.lua`)
- [x] 2.4 Create `lua/plugins/treesitter.lua` (migrate from LazyVim defaults + custom config)
- [x] 2.5 Create `lua/plugins/telescope.lua` (migrate from `plugins/navigation/telescope.lua`)
- [x] 2.6 Create `lua/plugins/gitsigns.lua` (migrate from LazyVim defaults)
- [x] 2.7 Create `lua/plugins/which-key.lua` (migrate from LazyVim defaults)
- [x] 2.8 Create `lua/plugins/mini.lua` (migrate mini.nvim modules: icons, move, pairs, splitjoin, surround)
- [x] 2.9 Create `lua/plugins/vim-tmux-navigator.lua` (migrate from `plugins/navigation/tmux.lua`)
- [x] 2.10 Create `lua/plugins/comment.lua` (migrate from `plugins/tools/comment.lua`)
- [ ] 2.11 Create `lua/plugins/todo-comments.lua` (migrate from `plugins/text/todo-comments.lua`)
- [ ] 2.12 Create `lua/plugins/undotree.lua` (migrate from `plugins/text/undotree.lua`)
- [ ] 2.13 Create `lua/plugins/neo-tree.lua` (migrate from `plugins/navigation/neo-tree.lua`)
- [ ] 2.14 Create `lua/plugins/harpoon.lua` (migrate from `plugins/navigation/harpoon.lua`)
- [ ] 2.15 Create `lua/plugins/conform.lua` (migrate from `plugins/tools/conform.lua`)
- [ ] 2.16 Create `lua/plugins/luasnip.lua` (migrate from `plugins/tools/luasnip.lua`)
- [ ] 2.17 Create `lua/plugins/snacks.lua` (migrate from `plugins/tools/snacks.lua`)
- [ ] 2.18 Create `lua/plugins/neogit.lua` (migrate from `plugins/tools/neogit.lua`)
- [ ] 2.19 Create `lua/plugins/lualine.lua` (migrate from `plugins/ui/ui.lua` or use snacks.winbar)
- [ ] 2.20 Create `lua/plugins/codesnap.lua` (migrate from `plugins/ai/codesnap.lua`)

## 3. LSP Configuration

- [x] 3.1 Create `lua/plugins/mason.lua` (mason.nvim setup)
- [x] 3.2 Create `lua/plugins/mason-lspconfig.lua` (mason-lspconfig with ensure_installed list)
- [x] 3.3 Create `lua/plugins/nvim-lspconfig.lua` (server setup, capabilities, on_attach)
- [x] 3.4 Configure lua_ls settings (runtime, workspace, diagnostics)
- [x] 3.5 Configure ts_ls / vtsls settings
- [x] 3.6 Configure gopls settings
- [x] 3.7 Configure rust_analyzer settings
- [x] 3.8 Configure pyright settings
- [x] 3.9 Add LSP keymaps (gd, K, gr, ca, rn, etc.)
- [x] 3.10 Add inlay hints toggle (`<leader>uh`)

## 4. Completion Configuration

- [ ] 4.1 Create `lua/plugins/blink-cmp.lua` (migrate from LazyVim defaults)
- [ ] 4.2 Configure completion sources (LSP, snippets, buffer, path)
- [ ] 4.3 Configure snippet expansion via luasnip

## 5. Language Support

- [ ] 5.1 Create `lua/plugins/go.lua` (migrate from `plugins/lang/go.lua`)
- [ ] 5.2 Create `lua/plugins/rust.lua` (migrate from `plugins/lang/rust.lua`)
- [ ] 5.3 Create `lua/plugins/python.lua` (migrate from `plugins/lang/python.lua`)
- [ ] 5.4 Create `lua/plugins/typescript.lua` (migrate from `plugins/lang/typescript.lua`)
- [ ] 5.5 Create `lua/plugins/gleam.lua` (migrate from `plugins/lang/gleam.lua`)

## 6. Cleanup

- [x] 6.1 Remove LazyVim dependency from `config/lazy.lua`
- [x] 6.2 Delete old nested `plugins/` directory structure
- [x] 6.3 Delete `plugins/init.lua` import manifest
- [x] 6.4 Remove unused plugins: dressing, telescope-ui-select, bufferline, noice, project, none-ls, format-on-save, efm, mason-conform, mason-null-ls, mason-nvim-dap, dap-ui, dap-virtual-text, goto-preview, neocomposer, edgy, focus
- [x] 6.5 Remove disabled plugin files: lsp-signature, hover, searchbox, fine-cmdline, dropbar, screenkey
- [x] 6.6 Verify no references to removed plugins remain (grep for old imports)

## 7. Verification

- [ ] 7.1 Test nvim startup (should be faster without LazyVim)
- [ ] 7.2 Test LSP works for all configured servers (lua, ts, go, rust, py)
- [ ] 7.3 Test format-on-save works for all filetypes
- [ ] 7.4 Test all keymaps work (especially `<leader>f`, `gd`, `K`, `gr`)
- [ ] 7.5 Test telescope, neo-tree, harpoon, which-key all functional
- [ ] 7.6 Test catppuccin theme loads correctly
- [ ] 7.7 Test treesitter highlighting works
- [ ] 7.8 Create commit: `refactor(nvim): replace LazyVim with minimalist config`
