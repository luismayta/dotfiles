## Why

The Hammerspoon configuration is functional but has accumulated dead code, duplicate logic, incomplete modules, and no validation pipeline. Cleaning these up reduces maintenance burden, makes the config easier to extend, and prevents future bugs.

## What Changes

- **Remove dead code**: Delete empty placeholder files in `src/mod/wifi/` and `src/core/utils/merge.lua`
- **Deduplicate overlapping modules**: Consolidate app hotkey management between `mod/apps/` and `mod/work/apps.lua`; resolve confusion between `mod/wifi/init.lua` and `mod/wifi.lua`; decide on `mod/system/notification.lua` vs `mod/notification_center.lua`
- **Wire config validation**: `schema.lua` defines validation rules but `config/loader.lua` never calls them — add validation on load
- **Generate custom.lua from template**: Instead of committing `custom.lua` directly, create `custom.lua.tpl` and generate it on `dotfiles::setup` or `hammerspoon::setup`
- **Fix typos**: `pomodoor` → `pomodoro` across all files (filename + references)
- **Add lint/validation**: `.luacheckrc` config and a pre-commit hook or task target for Lua validation
- **Add developer docs**: Brief docs on how to add new app bindings, spoon configs, and workspace profiles

## Capabilities

### New Capabilities
- `config-validation`: Wire schema.lua validation into the config loader pipeline so misconfiguration is caught early
- `custom-lua-generation`: Generate custom.lua from a template during setup, keeping user-specific overrides out of the repo
- `lint-pipeline`: Luacheck configuration and pre-commit hook for Hammerspoon Lua files
- `developer-docs`: Inline docs and/or README for extending app bindings, spoons, and profiles

### Modified Capabilities
- (empty — no existing specs are affected)

## Impact

- `zsh/modules/hammerspoon/data/`: Files to delete (dead code), rename (typo fix), and modify (dedup, validation wiring, template)
- `zsh/modules/hammerspoon/pkg/setup.zsh`: May need to invoke the custom.lua generation step
- No API breaking changes — all public module functions (`hammerspoon::sync`, `hammerspoon::setup`) keep their signatures
