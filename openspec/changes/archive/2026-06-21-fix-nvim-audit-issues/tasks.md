## 1. Keymap Consolidation

- [ ] 1.1 Remove `M.telescope()` function and its keymap definitions from `jasper/keymaps.lua`
- [ ] 1.2 Move the Telescope keymap definitions from `jasper/keymaps.lua` into `mappings.lua` if not already present
- [ ] 1.3 Verify no duplicate `<leader>ff`, `<leader>fg`, `<leader>fb` mappings exist

## 2. LSP Format Fixes

- [ ] 2.1 Fix `jasper/autocmds.lua` BufWritePre handler: replace `args.data.client_id` with `vim.lsp.get_clients({ bufnr = args.buf })`
- [ ] 2.2 Simplify `configs/lspconfig.lua` ts_ls setup: remove custom `on_attach`, use `features = { formatting = false }` via `jasper.server()`
- [ ] 2.3 Verify formatter triggers on save with correct LSP client

## 3. Module Lifecycle

- [ ] 3.1 Remove auto-execution of `M.setup()` from module body in `jasper/keymaps.lua` — keep the function defined
- [ ] 3.2 Delete `setup_hover()` function from `jasper/lsp.lua`
- [ ] 3.3 Add `vim.o.mousemoveevent = true` to `options.lua` (or confirm it's already set)
- [ ] 3.4 Remove empty `<leader>cs` mapping from `mappings.lua`

## 4. Auto-Import Hardening

- [ ] 4.1 Replace `dofile(path)` with `loadfile(path)()` in `scripts/auto-import.lua`

## 5. Options Error Visibility

- [ ] 5.1 Add `vim.notify()` warning inside the `pcall` in `options.lua` when `vim.o[k] = v` fails

## 6. Verification

- [ ] 6.1 Run `luac -p` on all modified Lua files — confirm zero syntax errors
- [ ] 6.2 Run `task build` from `zsh/modules/nvim/` — confirm auto-import still works
- [ ] 6.3 Run `nvim --headless -c "q"` — confirm no E21 error on startup
- [ ] 6.4 Interactive: verify keymaps, formatter, and LSP still function
