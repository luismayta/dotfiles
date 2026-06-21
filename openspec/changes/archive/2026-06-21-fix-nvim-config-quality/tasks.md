## 1. Fix Neovim Core Options

- [ ] 1.1 Uncomment the `for k, v in pairs(opt) do vim.opt[k] = v end` loop in `options.lua` (lines 60-62)
- [ ] 1.2 Verify `options.lua` loads without errors via `:lua require("options")`

## 2. Fix LSP Server Configuration

- [ ] 2.1 Remove `"tsserver"` from the generic `servers` list in `configs/lspconfig.lua` (line 27)
- [ ] 2.2 Migrate `tsserver` → `ts_ls` in `configs/lspconfig.lua` dedicated block (lines 77-85)
- [ ] 2.3 Migrate `tsserver` → `ts_ls` in `plugins/spec/lang/typescript.lua` (lines 13, 29)
- [ ] 2.4 Fix variable scope in `plugins/spec/lang/typescript.lua`: add `local nvlsp = require("nvchad.configs.lspconfig")` and `local on_attach` inside config function
- [ ] 2.5 Unify duplicate `on_attach` in `plugins/spec/lang/typescript.lua` — keep one with formatting disabled
- [ ] 2.6 Migrate `require("null-ls")` → `require("none-ls")` in `configs/lspconfig.lua` if kept, or remove the null-ls block
- [ ] 2.7 Remove `configs/mason-lspconfig.lua` if using manual LSP setup strategy

## 3. Fix Key Bindings

- [ ] 3.1 Fix `<leader>j` duplicate in `mappings.lua`: keep `:FocusSplitDown<CR>` at line 116, change line 117 to `<leader>J` → `:FocusSplitUp<CR>`
- [ ] 3.2 Fix `<leader>l` duplicate in `mappings.lua` — change to unique action (e.g., `FocusSplitRight`)
- [ ] 3.3 Resolve `<leader>f` conflict between `chadrc.lua` (diagnostic) and `lspconfig.lua` (format) — choose one or use different keys
- [ ] 3.4 Resolve `<leader>fc` conflict between `mappings.lua` (Telescope commands) and `ui.lua` (current_buffer_fuzzy_find)
- [ ] 3.5 Update Trouble commands from v2 API to v3 API in `mappings.lua` (lines 168-173):
  - `TroubleToggle` → `Trouble diagnostics toggle`
  - `Trouble workspace_diagnostics` → `Trouble diagnostics toggle filter.workspace`
  - `Trouble document_diagnostics` → `Trouble diagnostics toggle filter.buf=0`
  - `Trouble loclist` → `Trouble loclist toggle`
  - `Trouble quickfix` → `Trouble quickfix toggle`
  - `Trouble lsp_references` → `Trouble lsp_references toggle`
- [ ] 3.6 Fix `FocusSplitUP` → `FocusSplitUp` (camelCase) in `mappings.lua` (line 117)

## 4. Consolidate Formatting in conform.nvim

- [ ] 4.1 Move Go formatters from `configs/null-ls.lua` to `plugins/override/conform.lua` (gofmt, goimports_reviser, golines)
- [ ] 4.2 Remove `configs/null-ls.lua` if only used for formatting
- [ ] 4.3 Remove `null_ls.setup()` formatting block from `configs/lspconfig.lua` (lines 88-94)
- [ ] 4.4 Unify `<leader>fm` mapping — keep only in `plugins/override/conform.lua`

## 5. Fix Mason Setup

- [ ] 5.1 Change `M.mason.pkgs` → `M.mason.ensure_installed` in `chadrc.lua` (line 117)
- [ ] 5.2 Deduplicate `ensure_installed` lists across `mason.lua`, `mason-lspconfig.lua`, and `chadrc.lua`

## 6. Clean Up Dead Code and Deprecations

- [ ] 6.1 Remove commented DAP mappings block (lines 1-48) in `mappings.lua`
- [ ] 6.2 Remove unused `local nomap = vim.keymap.del` in `mappings.lua` (line 180)
- [ ] 6.3 Remove or import orphan config files: `configs/hop.lua`, `configs/illuminate.lua`, `configs/neoscroll.lua`, `configs/tabout.lua`, `configs/treesitter-context.lua`, `configs/visual-multi.lua`
- [ ] 6.4 Add rationale comment or remove disabled plugin specs: `plugins/spec/ai/ai.lua` (avante.nvim, codecompanion), `plugins/dankcolors.lua`
- [ ] 6.5 Remove unused sections from `configs/overrides.lua`: `M.ui.statusline`, `M.telescope`, `M.blankline`
- [ ] 6.6 Replace `jose-elias-alvarez/typescript.nvim` → `pmizio/typescript-tools.nvim` in `plugins/spec/lang/typescript.lua`
- [ ] 6.7 Centralize treesitter config — keep only the setup in `configs/overrides.lua`, remove from `typescript.lua`, `ts-autotag.lua`, and `ui.lua`
- [ ] 6.8 Remove `vim.lsp.buf.formatting()` fallback in `configs/lspconfig.lua` (line 16)
- [ ] 6.9 Verify `plugins.lua` root file is needed or remove it

## 7. Verification

- [ ] 7.1 Run `nvim --headless -c "lua vim.cmd('q')"` to verify no Lua errors
- [ ] 7.2 Verify `:lua vim.opt.tabstop:get() == 2` (options applied)
- [ ] 7.3 Verify all specs pass review
- [ ] 7.4 Run `Task lint` to verify codespell and formatting pass
