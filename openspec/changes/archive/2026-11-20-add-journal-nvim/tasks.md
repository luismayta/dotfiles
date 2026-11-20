# Tasks

## 1. Plugin spec

- [x] 1.1 Create `zsh/modules/nvim/data/lua/plugins/journal.lua` returning a lazy.nvim spec for `jakobkhansen/journal.nvim` with `cmd = "Journal"` and `opts = { filetype = "md", root = "~/notes/daily", journal = { entries = { day = { format = "%Y-%m-%d" } } } }`, and verify `luac -p zsh/modules/nvim/data/lua/plugins/journal.lua` exits 0
- [x] 1.2 Format the new spec to match `zsh/modules/nvim/data/.stylua.toml` (column_width 120, 2 spaces, double quotes) and verify `task lint` passes from `zsh/modules/nvim/`

## 2. Sync to Neovim config

- [x] 2.1 Run `nvim::sync` and verify `~/.config/nvim/lua/plugins/journal.lua` exists and matches the source file

## 3. Acceptance verification

- [x] 3.1 From an arbitrary directory (e.g. `/tmp`), run `nvim --headless "+Journal day" +q` and verify `~/notes/daily/<today YYYY-MM-DD>.md` is created with Neovim filetype `markdown`
- [x] 3.2 Run `:Journal day` a second time and verify it opens the same existing file without creating a duplicate or nested directories under `~/notes/daily`

## Workflow follow-up

- Archive the change after the project's review requirements are satisfied.
- Verify the archived result.
