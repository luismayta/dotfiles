## Context

The Hammerspoon config at `zsh/modules/hammerspoon/data/` has grown organically. A structural audit revealed:

- **Dead code**: 3 empty files in `src/mod/wifi/` (`function.lua`, `keys.lua`, `wifi.lua`) and `src/core/utils/merge.lua` (0 bytes)
- **Duplicate modules**: `mod/system/notification.lua` and `mod/notification_center.lua` are ~95% identical — both wrap DnD toggle + Caffeine + Pomodoro with the same AppleScript logic. `mod/notification_center.lua` is the newer version (has hotkey binding), `mod/system/notification.lua` is the stale original.
- **Broken dependency**: Both notification files require `core.functions` (`local fn = require("core.functions")`) which does not exist — this is a latent bug that surfaces if that code path is exercised.
- **Disabled validation**: `core/config/schema.lua` has a `M.validate()` function but `core/config/loader.lua` never calls it — config errors go undetected until runtime.
- **committed custom.lua**: `custom.lua` is user-specific keybinding overrides committed directly instead of generated from a template.
- **Typo**: `pomodoor` → `pomodoro` across filenames, require paths, and variable references.
- **No linting**: No `.luacheckrc` or validation pipeline for Hammerspoon Lua.

## Goals / Non-Goals

**Goals:**
- Remove dead code and fix latent bugs
- Deduplicate the notification modules into one
- Wire config schema validation into the load pipeline
- Generate `custom.lua` from a template instead of committing overrides
- Fix the `pomodoor` → `pomodoro` typo
- Add Luacheck config and wire it into the existing Taskfile validation pipeline
- Add developer-focused inline docs for extending the config

**Non-Goals:**
- Rewrite the architecture or change the module loading pattern
- Add new features (pomodoro timers, window management, etc.)
- Change any public API of the ZSH module (`hammerspoon::sync`, `hammerspoon::setup`)
- Modify existing Spoon source files (they're third-party)

## Decisions

1. **Consolidate notification into `mod/system/notification.lua`**: `mod/system/` is the established namespace for system-level modules (memory, speed, reload). Delete `mod/notification_center.lua` and move the hotkey binding from `notification_center.lua` into the consolidated file.

2. **Create `core/functions.lua`**: Extract the `setStatusNotification` helper function (called by both notification files but never defined) into a proper `core/functions.lua` module. Use the existing `hs.notify` API.

3. **Validation as a passive warning, not a hard error**: Wire `schema.validate()` into `config/loader.lua` using `xpcall` — print a warning on validation failure but don't block loading. This prevents misconfig from crashing Hammerspoon on reload.

4. **Template approach for custom.lua**: Create `custom.lua.tpl` with placeholder values. Add a `hammerspoon::generate-custom-config` function (or integrate into `hammerspoon::setup`) that copies the template to `~/.hammerspoon/custom.lua` only if the target doesn't already exist (idempotent).

5. **`.luacheckrc` at module root**: Standard Luacheck config with globals `hs` and `spoon`, std `lua5.3` (Hammerspoon uses Lua 5.3/5.4). Wire via `task validate` (already runs pre-commit hooks). Add luacheck to the pre-commit config if not present.

6. **Inline docs over separate files**: Add module-level `---@module` headers and usage comments to `src/mod/apps/config.lua`, `src/mod/work/config.lua`, `src/core/config/defaults.lua`, and `custom.lua.tpl` explaining the config schema — rather than creating a separate README that drifts from code.

## Risks / Trade-offs

- **[Risk] Template generation during setup**: If `hammerspoon::setup` runs before `hammerspoon::sync`, the template copy may overwrite the synced `custom.lua` → **Mitigation**: Only copy template if `~/.hammerspoon/custom.lua` doesn't exist; the sync always wins on re-runs.
- **[Risk] Renaming `pomodoor` → `pomodoro`**: The rename touches 4+ files. If any require path is missed, the module silently fails to load (pcall pattern swallows the error) → **Mitigation**: Use `ast_grep_search` to find ALL references before renaming; verify with `find . -name '*.lua' -exec grep -l 'pomodoor' {} \;`.
- **[Risk] Deleting `notification_center.lua`**: The `src/mod/windows.lua` file references `mod.notification_center` which becomes a broken require → **Mitigation**: Audit `require()` calls in all Lua files before deletion, update references.
