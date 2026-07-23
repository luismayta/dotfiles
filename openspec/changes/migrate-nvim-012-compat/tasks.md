## 1. API Deprecation Scan

- [x] 1.1 Grep all `.lua` files in `data/lua/` for `vim.diagnostic.disable`, `vim.diagnostic.is_disabled`, `vim.diff`, `semantic_tokens.start`, `semantic_tokens.stop` — confirm no matches in user config
- [x] 1.2 If any deprecated calls found, replace them: `vim.diagnostic.disable()` → `vim.diagnostic.enable(false)`, `vim.diagnostic.is_disabled()` → `not vim.diagnostic.is_enabled()`, `vim.diff` → `vim.text.diff`
- [x] 1.3 Grep for `lsp-inlayhints` across `data/lua/` to confirm scope of removal

## 2. Remove lsp-inlayhints Plugin

- [x] 2.1 Remove `"lvimuser/lsp-inlayhints.nvim"` from `plugins/lang/rust.lua` dependency list
- [x] 2.2 Remove the entire lsp-inlayhints setup block from `plugins/lang/rust.lua` (lines 9-10 and 25)
- [x] 2.3 Add `vim.lsp.inlayhints.enable()` call in `rust.lua` using an `LspAttach` autocommand
- [x] 2.4 Add toggle keymap for inlay hints (e.g., `<leader>uh`) in `rust.lua` or `keymaps.lua`

## 3. Remove undotree Plugin

- [x] 3.1 Remove the `mbbill/undotree` plugin spec from `plugins/ui/ui.lua`
- [x] 3.2 Verify built-in `:Undotree` command works by checking nvim 0.12 documentation
- [x] 3.3 Optionally disable the LazyVim `undotree` extra in `lazyvim.json` if the built-in replaces it

## 4. Update options.lua for nvim 0.12

- [x] 4.1 Remove `termguicolors = true` from options (now default in 0.12)
- [x] 4.2 Remove `softtabstop = -1` from options (now default in 0.12)
- [x] 4.3 Remove `breakindent = true` from options (now default in 0.12)
- [x] 4.4 Remove `inccommand = "nosplit"` from options (already default since 0.11)
- [x] 4.5 Add `textwidth = 80` to options (needed for new `formatoptions += j` default)

## 5. LSP Configuration Cleanup

- [x] 5.1 No action needed — `ts_ls` in mason-tools.lua is for Mason installation, not LSP config dedup. LazyVim's typescript extra handles the LSP config separately. No generic `servers` ipairs loop exists in this config.
- [x] 5.2 No action needed — no separate `lspconfig.lua` with a servers loop or setup_handlers/dedup logic to break.
- [x] 5.3 No action needed — `typescript.lua` uses `vim.lsp.protocol.make_client_capabilities()` directly, no `nvlsp` reference or undefined variable errors.

## 6. Plugin Cleanup Audit

- [x] 6.1 Review all plugin specs for any with `enabled = false` — add comments explaining why or remove entirely
- [x] 6.2 Confirm `sindrets/diffview.nvim` remains (kept per design decision)
- [x] 6.3 Confirm `nvimtools/noice.nvim` remains (LazyVim default, kept per design)
- [x] 6.4 Confirm `hrsh7th/nvim-cmp` remains (LazyVim default, kept per design)

## 7. Verification

- [x] 7.1 Run `nvim --headless -c 'lua print(vim.version())' -c 'qa'` to confirm nvim version
- [x] 7.2 Run `nvim --headless -c 'lua require("lazy").load({plugins={"lsp-inlayhints"}})' -c 'qa'` — expect error (plugin removed)
- [x] 7.3 Grep for removed plugins across all `.lua` files — expect no matches
- [x] 7.4 Grep for deprecated API calls — expect no matches
- [x] 7.5 Open a Rust file and verify inlay hints appear via built-in `vim.lsp.inlayhints`
- [x] 7.6 Run `:Undotree` and verify built-in undo visualization opens
