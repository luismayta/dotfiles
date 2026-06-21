## Why

The jasper module audit (MartinFowler, 2026-06-21) identified 10 quality issues (3 high severity) in the `enhance-nvim-with-nvchad-patterns` change. These issues affect formatter reliability, keymap consistency, module lifecycle correctness, and code maintainability. Fixing them before committing is necessary to ship a stable, production-ready module.

## What Changes

1. **Consolidate Telescope keymap source of truth** — Remove duplication between `jasper/keymaps.lua` and `mappings.lua`; pick one canonical source
2. **Fix `M.setup()` auto-execution** — Stop running keymap registration at `require()` time; make it explicitly callable after plugin loading
3. **Fix `BufWritePre` formatter** — Replace `args.data.client_id` with correct buffer client lookup so auto-formatting actually works
4. **Remove dead code** — Delete `setup_hover()` (only sets `mousemoveevent`, no hover logic)
5. **Deduplicate formatting config** — Remove double `documentFormattingProvider = false` in `ts_ls` setup
6. **Harden `combine_lists`** — Document the string-only constraint or add table serialization support
7. **Improve error visibility** — Replace silent `pcall` in `options.lua` with explicit error logging
8. **Harden auto-import validation** — Use `loadfile` instead of `dofile` to avoid executing file side effects during validation
9. **Enable lazy submodule loading** — Defer `jasper` submodule loading to reduce startup cost
10. **Clean empty keymap** — Remove or implement `<leader>cs` with empty command

## Capabilities

### New Capabilities

- `keymap-consolidation`: Consolidate duplicated keymap definitions between `jasper/keymaps.lua` and `mappings.lua` into a single source of truth
- `lsp-format-fix`: Fix BufWritePre auto-formatting and deduplicate formatting configuration across lspconfig and jasper modules
- `module-lifecycle`: Fix eager `M.setup()` execution, enable lazy submodule loading, remove dead code
- `auto-import-hardening`: Replace `dofile` with `loadfile` for spec validation to prevent side effects
- `options-error-visibility`: Replace silent `pcall` swallowing in options.lua with explicit error handling

### Modified Capabilities

<!-- No existing spec-level behavior is changing; all fixes are implementation-level corrections to code written in the current change. -->

## Impact

- **Files modified**: `jasper/keymaps.lua`, `jasper/autocmds.lua`, `jasper/lsp.lua`, `jasper/utils.lua`, `jasper/init.lua`, `configs/lspconfig.lua`, `mappings.lua`, `scripts/auto-import.lua`, `options.lua`
- **Dependencies**: No new dependencies. All changes are within the existing nvim module.
- **Breaking changes**: None. All fixes are backward-compatible corrections.
