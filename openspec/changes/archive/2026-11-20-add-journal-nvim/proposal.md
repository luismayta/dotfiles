# Proposal

## Why

The user needs an Obsidian-style daily notes workflow inside Neovim: one Markdown file per day (`YYYY-MM-DD.md`) stored at a fixed absolute path, openable from any working directory, without depending on the Obsidian app or a vault. Prior research (`.codi/inbox/research/researched/2026-11-19-neovim-daily-notes-plugins.md`) concluded that `jakobkhansen/journal.nvim` (MIT, zero dependencies) satisfies all three requirements: dated note files, a cwd-independent configurable root, and a global `:Journal` command.

## What Changes

- Add the lazy.nvim plugin spec `zsh/modules/nvim/data/lua/plugins/journal.lua` declaring `jakobkhansen/journal.nvim`.
- Configure the plugin with `filetype = "md"`, `root = "~/notes/daily"`, and `journal.entries.day.format = "%Y-%m-%d"` (flat Obsidian-style files instead of the plugin's default nested path).
- Expose the global `:Journal day` command that creates or opens `<root>/YYYY-MM-DD.md` from any directory.
- Sync `zsh/modules/nvim/data/` to `~/.config/nvim` via `nvim::sync` so lazy.nvim auto-discovers the new spec.

## Capabilities

### New Capabilities

- `daily-notes`: Obsidian-style daily notes in Neovim — create/open one Markdown note per day at a fixed absolute root, independent of the current working directory.

### Modified Capabilities

_(none — no existing spec-level requirements change)_

## Impact

- New file: `zsh/modules/nvim/data/lua/plugins/journal.lua` (no existing files modified).
- New plugin dependency: `jakobkhansen/journal.nvim` (MIT, no external dependencies), managed by lazy.nvim auto-discovery in `lua/config/lazy.lua`.
- Deployment: requires `nvim::sync` (rsync `data/` → `~/.config/nvim`); `~/.config/nvim` changes on next sync.
- Verification: `task lint` (`luac -p` via `zsh/modules/nvim/Taskfile.yml`) and StyLua formatting (`zsh/modules/nvim/data/.stylua.toml`, column_width 120, 2 spaces).
- Notes root `~/notes/daily` lives outside the repo; the plugin creates it on first use.
