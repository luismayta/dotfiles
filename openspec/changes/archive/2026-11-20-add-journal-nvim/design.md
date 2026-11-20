# Design

## Context

Source of truth for the nvim module is `zsh/modules/nvim/data/`, rsynced to `~/.config/nvim` by `nvim::sync` (`zsh/modules/nvim/internal/base.zsh:23-38`). lazy.nvim auto-discovers specs via `{ import = "plugins" }` (`zsh/modules/nvim/data/lua/config/lazy.lua:28-29`); 23 spec files exist and `journal.lua` is not among them. Closest style match: `indent-blankline.lua` (pure `opts` table). Lint: `task lint` runs `luac -p` (`zsh/modules/nvim/Taskfile.yml:15-20`); formatting: `zsh/modules/nvim/data/.stylua.toml` (column_width 120, 2 spaces). See proposal.md - Why.

## Goals / Non-Goals

**Goals:**
- One new file `zsh/modules/nvim/data/lua/plugins/journal.lua` following the existing spec style.
- Flat daily notes at `~/notes/daily/YYYY-MM-DD.md` openable from any cwd via `:Journal day`.
- Verification through `task lint` and a manual acceptance run after `nvim::sync`.

**Non-Goals:**
- Note templates, weekly/monthly notes, backlinks, wiki-links, or Obsidian aesthetics.
- Adopting obs.nvim, obsidian.nvim, or a native hand-rolled command.
- Custom keybindings for the plugin (command-only entry point).

## Decisions

1. **journal.nvim over alternatives** — Research (`.codi/inbox/research/researched/2026-11-19-neovim-daily-notes-plugins.md`) verified it meets all three requirements with MIT license, zero dependencies, and active maintenance. obs.nvim adds vault aesthetics not required; daily-notes.nvim is AGPL; a native ~6-line command was rejected because it duplicates format/root logic that the plugin already provides and offers no extension path.
2. **lazy.nvim `opts` table with `cmd = "Journal"` trigger** — lazy.nvim calls `require("journal").setup(opts)` automatically on first `:Journal` invocation, so no `config` function is needed; matches the `indent-blankline.lua` style. Command-triggered loading keeps the plugin out of startup until used. Alternative (eager `event = "VeryLazy"`) rejected: no reason to load a command-only plugin at startup.
3. **`root = "~/notes/daily"`** — fixed absolute path outside the repo, expanded by the plugin; selected by user decision during planning. The plugin's default nested layout (`%Y/%m-%B/daily/%d-%A`) is overridden with `journal.entries.day.format = "%Y-%m-%d"` for flat Obsidian-style files.
4. **`filetype = "md"`** — the plugin's `filetype` option sets the note file extension to `.md`; it does not set the buffer filetype, which Neovim built-in detection resolves to `markdown`. This keeps notes compatible with other Markdown tooling (treesitter, formatters, lualine) that key off `markdown`.

## Risks / Trade-offs

- [Upstream plugin becomes unmaintained] → MIT with zero dependencies; the capability spec stays valid and a fallback is the native command or a vendored copy.
- [Notes root lives outside the repo, untracked and unbacked] → accepted: notes are personal data, not configuration; user decision.
- [First run creates `~/notes/daily` implicitly] → plugin creates the root on demand; acceptance test verifies creation.
- [rsync `--delete` during `nvim::sync` could remove the config] → the spec file lives inside `data/`, so it is copied by sync; notes live outside `data/` and are unaffected.

## Migration Plan

1. Create the plugin spec file.
2. Run `task lint` to verify Lua syntax and StyLua formatting.
3. Run `nvim::sync` to copy `data/` → `~/.config/nvim`.
4. Open Neovim from an arbitrary directory and run `:Journal day` as the acceptance test.

Rollback: delete `zsh/modules/nvim/data/lua/plugins/journal.lua`, re-run `nvim::sync` (rsync `--delete` removes it from `~/.config/nvim`), restart Neovim.
