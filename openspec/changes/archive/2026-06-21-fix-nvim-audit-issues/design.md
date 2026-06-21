## Context

The jasper module was implemented as part of `enhance-nvim-with-nvchad-patterns` (30 tasks, 7 phases). A post-implementation audit by MartinFowler identified 10 issues (3 high severity) spanning keymap duplication, formatter bugs, module lifecycle problems, and code quality. All affected files live under `zsh/modules/nvim/data/lua/`.

MartinFowler's full audit is available in the conversation history (2026-06-21).

## Goals / Non-Goals

**Goals:**
- Fix 3 high-severity bugs: duplicated keymaps, auto-`require()` side effects, broken BufWritePre formatter
- Fix 7 medium/low issues: dead code, deduplication, error visibility, validation hardening
- All fixes are backward-compatible — no breaking changes to the public API
- Ship a stable, audited jasper module ready for commit

**Non-Goals:**
- No new features or capabilities
- No architectural redesign of the jasper module
- No changes outside `zsh/modules/nvim/`

## Decisions

### 1. Source of truth for keymaps: `mappings.lua` wins

**Decision**: Keep Telescope keymaps only in `mappings.lua` (the pre-existing pattern). Remove the `M.telescope()` function from `jasper/keymaps.lua`.

**Rationale**: `mappings.lua` is the established keymap file that already existed before jasper. It has a consistent pattern with `map()` calls and `{ desc = ... }` annotations. Moving all Telescope maps there eliminates ambiguity. The jasper telescope module still provides the wrapper functions (`jasper.telescope.ff()`, etc.) — they're just called from `mappings.lua` instead of being redefined.

**Alternative considered**: Moving everything into `jasper/keymaps.lua` — rejected because it would break the existing convention and require migrating dozens of non-jasper keymaps.

### 2. `M.setup()` becomes explicit

**Decision**: Remove the `M.setup()` call from the module body in `jasper/keymaps.lua`. The function remains defined but must be called explicitly (e.g., from `init.lua` after plugin loading).

**Rationale**: Auto-execution at `require()` time registers LSP keymaps before any LSP buffer exists, making them no-ops (the `buffer = bufnr` pattern requires a valid buffer handle). Explicit lifecycle gives callers control over timing.

### 3. Fix `BufWritePre` formatter with `vim.lsp.get_clients`

**Decision**: Replace `args.data.client_id` (which doesn't exist on `BufWritePre`) with `vim.lsp.get_clients({ bufnr = args.buf })` to find the correct LSP client for the buffer being saved.

**Rationale**: `BufWritePre` passes `{ buf, file }` in the event table, not `{ data = { client_id = ... } }` (which is `LspAttach`-specific). Using the buffer-scoped client lookup is the standard nvim pattern for format-on-save.

### 4. Remove `setup_hover()` dead code

**Decision**: Delete the `setup_hover()` function from `jasper/lsp.lua`. Move `vim.o.mousemoveevent = true` to `options.lua` if not already set there.

**Rationale**: The function's only effect was setting `mousemoveevent`. The comment inside it admits hover is handled elsewhere. Options belong in `options.lua`, not scattered across modules.

### 5. Single formatting policy for `ts_ls`

**Decision**: Remove the custom `on_attach` in `configs/lspconfig.lua` for `ts_ls`. Let `jasper.server()` and `jasper.on_attach()` handle it uniformly.

**Rationale**: The current code disables formatting twice (once in the custom `on_attach`, once inside `jasper.on_attach`). Passing `features = { formatting = false }` to `jasper.server()` achieves the same result cleanly.

### 6. `combine_lists` stays string-only but documented

**Decision**: Add a comment documenting that `combine_lists` uses reference hashing and only guarantees deduplication for string/primitive values. No code change.

**Rationale**: All current callers pass string arrays. Adding table serialization would add complexity without current benefit.

### 7. `pcall` stays but adds warning

**Decision**: Keep `pcall` for headless resilience but add a `vim.notify` call on failure so errors are visible.

**Rationale**: The error is harmless (utf-8 default) in headless mode, but should be visible during debugging. This balances resilience with observability.

### 8. `loadfile` replaces `dofile` in auto-import

**Decision**: Use `loadfile(path)()` instead of `dofile(path)` for spec validation. `loadfile` compiles without executing top-level side effects.

**Rationale**: `dofile` executes the entire file including side effects. `loadfile` returns a function that only executes what's necessary when called. Both evaluate the return value the same way.

### 9. Lazy submodule loading deferred

**Decision**: No change. The current eager `require` pattern is acceptable for the current module size (~200 lines total across submodules). Revisit if the module grows significantly.

**Rationale**: Optimizing load time for ~6 small files is premature. The audit mark stands as a note for future optimization.

### 10. `<leader>cs` removed

**Decision**: Remove the `<leader>cs` empty mapping from `mappings.lua`.

**Rationale**: A mapping with `<cmd><CR>` as the command does nothing. If a statusline clear action is needed, it should be implemented properly — not left as a placeholder.

## Risks / Trade-offs

- **[Low] Explicit `setup()` call could be forgotten** — Mitigation: add a comment in `init.lua` and document in the function docstring
- **[Low] `loadfile` changes validation behavior** — All spec files return tables at the top level, so `loadfile` produces the same result as `dofile`. No functional difference.
- **[Low] Removing `setup_hover()` could break mouse hover** — `mousemoveevent` will be moved to `options.lua`, preserving the functionality.
