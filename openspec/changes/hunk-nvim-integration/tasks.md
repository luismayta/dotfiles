## 1. Plugin Spec Scaffold

- [ ] 1.1 Create `zsh/modules/nvim/data/lua/plugins/tools/hunk.lua` with the virtual plugin spec structure (empty name, `cmd` for lazy-loading, `config` function)
- [ ] 1.2 Add `cmd` entries for `HunkDiff`, `HunkShow`, `HunkDaemon` to enable lazy-loading
- [ ] 1.3 Register the plugin spec in `zsh/modules/nvim/data/lua/plugins/init.lua` (should auto-detect by being in the `plugins/` directory)

## 2. HunkDiff Command Implementation

- [ ] 2.1 Implement `:HunkDiff` command in the `config` function that calls `vim.fn.executable("hunk")` and shows a warning if not found
- [ ] 2.2 Implement terminal launch using `Snacks.terminal` with a floating window layout (width 0.8, height 0.8, border "rounded")
- [ ] 2.3 Define `<leader>hd` keymap for `:HunkDiff`
- [ ] 2.4 Implement `:HunkDiff --watch` support and `<leader>hw` keymap
- [ ] 2.5 Implement `<leader>hq` keymap to close the hunk terminal if open

## 3. HunkShow Command Implementation

- [ ] 3.1 Implement `:HunkShow` command that accepts an optional commit reference argument
- [ ] 3.2 Default to `HEAD` when no argument is provided
- [ ] 3.3 Implement `<leader>hs` keymap with `vim.ui.input` prompt for commit reference
- [ ] 3.4 Launch the terminal with `hunk show <ref>` using Snacks.terminal

## 4. HunkDaemon Command Implementation

- [ ] 4.1 Implement `:HunkDaemon` toggle command with module-level state tracking (running/stopped + PID)
- [ ] 4.2 Implement daemon start using `vim.fn.jobstart("hunk daemon serve")` with notification
- [ ] 4.3 Implement daemon stop using `vim.fn.jobstop()` with notification
- [ ] 4.4 Define `<leader>hdm` keymap for `:HunkDaemon`
- [ ] 4.5 Handle edge case: Neovim exit with daemon still running (job auto-terminates)

## 5. Verification

- [ ] 5.1 Verify Lazy.nvim loads the spec without errors (`:Lazy` shows the entry)
- [ ] 5.2 Verify `:HunkDiff` opens floating terminal and hunk TUI is interactive
- [ ] 5.3 Verify `:HunkShow HEAD` opens terminal with commit diff
- [ ] 5.4 Verify `:HunkDaemon` toggles daemon on/off with correct notifications
- [ ] 5.5 Verify warning notification appears when hunk is not installed
- [ ] 5.6 Verify all keymaps work: `<leader>hd`, `<leader>hw`, `<leader>hs`, `<leader>hdm`, `<leader>hq`
