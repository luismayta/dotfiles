## Context

The nvim module at `zsh/modules/nvim/data/` is a LazyVim v8 configuration with 57+ Lua files and plugins. CodeGraph analysis confirmed no direct usage of deprecated APIs (`vim.diagnostic.disable()`, `vim.diagnostic.is_disabled()`, `vim.diff`) in user config files. However, several installed plugins duplicate functionality now available as nvim built-ins in 0.12:

- `lvimuser/lsp-inlayhints.nvim` → `vim.lsp.inlayhints` (used in `plugins/lang/rust.lua`)
- `mbbill/undotree` → `:Undotree` built-in (used in `plugins/ui/ui.lua`)
- `sindrets/diffview.nvim` → `:DiffTool` built-in (used in `plugins/tools/diffview.lua`)
- `nvimtools/noice.nvim` → `vim._core.ui2` (LazyVim default, not in user config)
- `hrsh7th/nvim-cmp` → `vim.lsp.completion.enable()` (LazyVim default, not in user config)

Reference: https://github.com/Sin-cy/dotfiles already uses `vim._core.ui2` and other 0.12 features.

## Goals / Non-Goals

**Goals:**
- Eliminate deprecated API usage that will break on nvim 0.12 upgrade
- Replace plugin-based features with built-in alternatives where stable
- Simplify `options.lua` by removing options now default in 0.12
- Maintain full LazyVim compatibility throughout migration

**Non-Goals:**
- Replace lazy.nvim with vim.pack (too experimental, breaks LazyVim ecosystem)
- Remove nvim-cmp in favor of vim.lsp.completion (too risky, LazyVim depends on cmp)
- Rewrite LSP config from scratch (incremental migration only)
- Change plugin selection beyond 0.12 built-in replacements

## Decisions

### D1: Incremental migration over big-bang rewrite
**Choice**: Migrate API calls and replace individual plugins, keep LazyVim architecture intact.
**Why**: LazyVim v8 manages 57+ plugins with complex interdependencies. A full rewrite risks losing battle-tested configs. Incremental changes are testable per-step.
**Alternatives considered**: Full rewrite with vim.pack — rejected because vim.pack is experimental and LazyVim doesn't support it yet.

### D2: Remove lsp-inlayhints.nvim, use built-in vim.lsp.inlayhints
**Choice**: Remove `lvimuser/lsp-inlayhints.nvim` dependency from `rust.lua` and configure `vim.lsp.inlayhints` directly.
**Why**: Built-in is guaranteed stable, no external dependency, nvim 0.12 has mature inlay hints. CodeGraph shows it's only used in `rust.lua:9-10,25`.
**Alternatives considered**: Keep both — rejected to avoid duplicate inlay hint rendering.

### D3: Replace undotree.nvim with built-in :Undotree
**Choice**: Remove `mbbill/undotree` plugin spec from `ui/ui.lua` and use `:Undotree` command.
**Why**: Built-in undotree is a direct 1:1 replacement. LazyVim undotree extra already exists but can be disabled if built-in works.
**Alternatives considered**: Keep plugin — rejected because built-in eliminates a dependency.

### D4: Defer diffview.nvim replacement
**Choice**: Keep `sindrets/diffview.nvim` for now; `:DiffTool` is not a full replacement for DiffviewOpen/DiffviewFileHistory workflows.
**Why**: Diffview has deeper git integration (file history, branch diff) that `:DiffTool` doesn't match. Replacing would lose functionality.
**Alternatives considered**: Remove diffview — rejected, would break existing git diff workflows.

### D5: Defer noice.nvim and nvim-cmp replacement
**Choice**: Keep LazyVim defaults for noice.nvim and nvim-cmp.
**Why**: `vim._core.ui2` is experimental and may break LazyVim's notification system. `vim.lsp.completion` lacks cmp's snippet expansion and source diversity. Both are LazyVim-managed defaults, not user config.
**Alternatives considered**: Evaluate vim._core.ui2 — deferred to a future change when APIs stabilize.

### D6: Update options.lua for 0.12 defaults
**Choice**: Remove `termguicolors`, `softtabstop`, `breakindent`, `inccommand` (now defaults). Add `textwidth = 80` for the new `formatoptions` `j` default.
**Why**: Declaring defaults wastes config lines and can mask future behavior changes. `textwidth = 80` ensures `formatoptions += j` (auto-join) works predictably.

## Risks / Trade-offs

- [Risk] Built-in :Undotree may have fewer features than mbbill/undotree → Mitigation: Test undo visualization before removing plugin; keep plugin as fallback
- [Risk] vim.lsp.inlayhints may have different rendering than lsp-inlayhints.nvim → Mitigation: Test with Go/Rust LSP servers; adjust highlight groups if needed
- [Risk] LazyVim updates may re-add disabled plugins → Mitigation: Document disabled extras in lazyvim.json; use `enabled = false` in plugin specs
- [Risk] vim._core.ui2 is experimental and may change → Mitigation: Defer to future change; noice.nvim works fine
- [Trade-off] Keeping diffview.nvim means one more plugin → Acceptable: diffview provides functionality :DiffTool doesn't
