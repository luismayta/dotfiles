## Context

The nvim module was recently refactored to use composable jasper modules for LSP, keymaps, telescope, and autocmds. This left behind orphaned config files, dead plugin specs, broken requires, and duplicate mappings. The module currently has ~52 Lua files, many of which are never loaded. This design addresses the cleanup.

The module has a dual architecture:
- **Legacy NvChad layer**: `chadrc.lua`, `configs/*.lua`, `plugins/spec/*.lua` — NvChad v2.5 patterns
- **Jasper module**: `jasper/*.lua` — newer composable abstraction
- **Zsh glue**: `plugin.zsh` → `config/`, `internal/`, `pkg/`

## Goals / Non-Goals

**Goals:**
- Delete all orphaned config files not referenced by any plugin spec
- Delete unreferenced plugin specs and their `enabled=false` imports
- Fix the broken `configs.mason-lspconfig` require that blocks LSP auto-install
- Remove dead Lspsaga code from `chadrc.lua`
- Delete `jasper/keymaps.lua` (dead code, logic duplicated in `jasper/lsp.lua`)
- Remove duplicate telescope mappings from `spec/ui/ui.lua`
- Consolidate duplicate BufWritePre format-on-save
- Fix `NVIM_FILE_SETTINGS` path in zsh config
- All changes must pass `luac -p`, `task nvim:build`, and `nvim --headless`

**Non-Goals:**
- Not upgrading NvChand from v2.5 to v3.0 (separate effort, high risk)
- Not rewriting `chadrc.lua` entirely — only removing dead parts
- Not adding new features or refactoring working code
- Not changing the plugin spec format or structure

## Decisions

1. **Delete orphaned configs, don't archive them**
   - Files to delete: `configs/mason.lua`, `configs/neoscroll.lua`, `configs/treesitter-context.lua`, `configs/hop.lua`, `configs/tabout.lua`, `configs/illuminate.lua`, `configs/visual-multi.lua`
   - Rationale: They contain only setup/config code for plugins that are no longer installed. No user state or important logic worth preserving. Git history retains them if needed.

2. **Fix mason.lua spec instead of creating missing config**
   - Change `configs.mason-lspconfig` require to `configs.mason` in `spec/lsp/mason.lua`
   - Rationale: The `configs/mason.lua` file already exists with the full `ensure_installed` list. Creating a second file or renaming adds unnecessary churn. The require path was simply wrong.

3. **Delete `plugins/dankcolors.lua` entirely**
   - Rationale: 92-line custom colorscheme that is not imported in `plugins/init.lua`. Has a self-referencing file watcher. Not registered with lazy.nvim anywhere. Pure dead code.

4. **Remove dead Lspsaga from `chadrc.lua`, leave NvChad renamer**
   - Keep `require("nvchad_ui.renamer").open()` but update to `require("nvchad.ui.renamer").open()` for forward compatibility
   - Remove all 5 Lspsaga command mappings and the `K` hover override
   - Rationale: Lspsaga is not installed. The renamer is still available in NvChad v2.5.

5. **Remove `jasper/keymaps.lua` entirely**
   - `M.setup()` is never called from `jasper/init.lua` or anywhere else
   - `M.lsp(bufnr)` logic is fully duplicated in `jasper/lsp.lua:7-24`
   - Remove the file and its `require` line from `jasper/init.lua`

6. **Remove 7 disabled plugin imports + their spec files**
   - From `plugins/init.lua`: Remove imports for `searchbox`, `fine-cmdline`, `project`, `autosession`, `neocomposer`, `lsp-signature`, `hover`
   - Delete their spec files
   - Rationale: `enabled = false` still causes lazy.nvim to scan them. Deleting saves startup time.

7. **Duplicate telescope mappings: remove from spec, keep jasper**
   - Delete telescope mappings from `spec/ui/ui.lua:93-127`
   - Keep the jasper.telescope wrappers in `mappings.lua:100-108`
   - Rationale: jasper wrappers are the canonical source. Having mappings in two places causes conflicts (`<leader>fr` = resume vs lsp_references).

8. **Duplicate format-on-save: keep in autocmds, remove from jasper/lsp.lua**
   - Remove the `BufWritePre` autocmd creation from `jasper/lsp.lua:67-74`
   - Keep the global one in `jasper/autocmds.lua:7-19`
   - Rationale: The autocmds.lua version is simpler and catches all LSP buffers without needing per-buffer setup in every `on_attach`.

9. **Zsh fixes: path correction and variable removal**
   - `NVIM_FILE_SETTINGS`: Change `/lua/config/options.lua` → `/lua/options.lua`
   - `NVIM_ROOT_PATH`: Remove as it duplicates `NVIM_CONFIG_PATH`

## Risks / Trade-offs

- **[Delete vs keep]**: Deleting files is safe because they're confirmed unreferenced, but if something dynamically requires them, it breaks. → Mitigation: Run `rg "require.*configs\.(mason|neoscroll|treesitter-context|hop|tabout|illuminate|visual-multi)"` to confirm zero references before deleting.
- **[Mason spec change]**: Changing the require path could break if `configs.mason` exports a different shape than what the spec expects. → Mitigation: Read both files to verify their return tables are compatible before changing.
- **[Duplicate format-on-save]**: Removing from lsp.lua could break format-on-save for buffers attached before autocmds.lua is loaded. → Mitigation: autocmds.lua runs at the `UIEnter` event, which fires after all LSP clients are initialized. Safe to centralize there.
- **[Lspsaga removal in chadrc]**: If user muscle-memory uses `<leader>ca` for code action, it will stop working. → Mitigation: The jasper module maps `<leader>la` in `keymaps.lua` which was the intended replacement, so this is a non-issue.

## Migration Plan

1. Delete orphaned config files (8 files)
2. Delete `plugins/dankcolors.lua`
3. Delete `jasper/keymaps.lua` + update `jasper/init.lua` require
4. Fix `spec/lsp/mason.lua` require path
5. Remove Lspsaga dead code from `chadrc.lua`
6. Remove disabled plugin imports from `plugins/init.lua` + delete spec files
7. Remove duplicate telescope mappings from `spec/ui/ui.lua`
8. Remove duplicate format-on-save from `jasper/lsp.lua`
9. Fix zsh config paths and variables
10. Run `mvim --headless` to verify no load errors
11. Run `task nvim:build` to regenerate plugin imports
12. Run `luac -p` on all remaining Lua files

Rollback: `git checkout HEAD -- <file>` for any individual change. The changes are small and independent.
