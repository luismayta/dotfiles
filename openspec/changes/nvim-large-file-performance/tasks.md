## 1. Folding optimization (treesitter-folding)

- [ ] 1.1 Change `opt.foldmethod` from `"expr"` to `"indent"` and remove `opt.foldexpr` in `options.lua`
- [ ] 1.2 Add `:FoldTS` command to toggle treesitter folding on-demand via `vim.api.nvim_create_user_command` in `autocmds.lua` or a new `commands.lua`

## 2. Format-on-save deduplication (format-on-save)

- [ ] 2.1 Remove the `BufWritePre` autocmd block (lines 8-19) from `autocmds.lua` that iterates LSP clients and calls `vim.lsp.buf.format`
- [ ] 2.2 Verify `conform.nvim`'s `format_on_save` is properly configured as the sole formatting mechanism

## 3. Cursor-move optimization (cursor-move)

- [ ] 3.1 Set `opt.mousemoveevent = false` in `options.lua`
- [ ] 3.2 Add `current_line_blame_opts = { delay = 500 }` to gitsigns config in `plugins/tools/git.lua`
- [ ] 3.3 Set `indent = { enable = false }` in nvim-treesitter opts (remove or comment out `indent = { enable = true }` in `plugins/ui/ui.lua` or wherever treesitter is configured)

## 4. Buffer events optimization (buffer-events)

- [ ] 4.1 Change `harpoon` event from `"BufEnter"` to `"VeryLazy"` in `plugins/navigation/harpoon.lua`
- [ ] 4.2 Change `regexplainer` event from `"BufEnter"` to `"VeryLazy"` in `plugins/text/regexplainer.lua`
- [ ] 4.3 Remove `event = "BufReadPost"` from `vim-surround` in `plugins/tools/productivity.lua` (let lazy.nvim handle it via keymaps)
- [ ] 4.4 Change `scrollEOF` event from `{ "CursorMoved", "WinScrolled" }` to `"VeryLazy"` in `plugins/text/scrolleof.lua`

## 5. General config cleanup

- [ ] 5.1 Review `lazy = false` plugins in `plugins/lang/` and change to lazy loading where possible (e.g., `vim-graphql`, `vim-terraform`)
- [ ] 5.2 Verify no regressions by opening small and large files after all changes

## Verify

- [ ] V.1 Open a 1000+ line file and measure perceived latency before/after
- [ ] V.2 Confirm `:FoldTS` command exists and toggles treesitter folding
- [ ] V.3 Confirm format-on-save still works via conform
- [ ] V.4 Confirm gitsigns blame still displays after 500ms delay
- [ ] V.5 Check Neovim starts without errors: `nvim --headless -c 'qa'`
