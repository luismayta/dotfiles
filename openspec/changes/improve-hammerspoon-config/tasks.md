## 1. Cleanup Dead Code & Fix Typos

- [ ] 1.1 Delete empty placeholder files: `src/mod/wifi/function.lua`, `src/mod/wifi/keys.lua`, `src/mod/wifi/wifi.lua`
- [ ] 1.2 Delete empty file: `src/core/utils/merge.lua`
- [ ] 1.3 Find ALL references to `pomodoor` across the data directory (`require('mod.pomodoor')`, filename, variable names)
- [ ] 1.4 Rename `src/mod/work/pomodoor.lua` → `src/mod/work/pomodoro.lua`
- [ ] 1.5 Update all `require("mod.pomodoor")` to `require("mod.pomodoro")` across all Lua files
- [ ] 1.6 Rename `pomodor` variable/function references to `pomodoro` inside the module file and all consumers

## 2. Deduplicate Notification Modules

- [ ] 2.1 Audit all `require("mod.notification_center")` and `require("mod.system.notification")` references across the codebase
- [ ] 2.2 Incorporate the hotkey binding from `notification_center.lua` into `mod/system/notification.lua`
- [ ] 2.3 Delete `src/mod/notification_center.lua`
- [ ] 2.4 Create `src/core/functions.lua` with the shared `setStatusNotification` helper (used by notification and other modules)
- [ ] 2.5 Update all require paths to point to the consolidated `mod.system.notification` module

## 3. Wire Config Schema Validation

- [ ] 3.1 Add `local schema = require("core.config.schema")` import to `src/core/config/loader.lua`
- [ ] 3.2 Add validation call using `xpcall(schema.validate, ...)` after all config layers are merged
- [ ] 3.3 Log validation warnings via `hs.logger` instead of crashing on error
- [ ] 3.4 Verify that the existing schema.lua covers all config fields actually used in the project

## 4. Generate custom.lua from Template

- [ ] 4.1 Rename `src/custom.lua` → `src/custom.lua.tpl` and replace real values with documented placeholder values
- [ ] 4.2 Add `custom.lua` to `.gitignore` at the data directory root
- [ ] 4.3 Add `core::generate-custom-config` function to `zsh/modules/hammerspoon/pkg/setup.zsh` (only copy if target doesn't exist)
- [ ] 4.4 Wire the template generation into the existing `hammerspoon::setup` flow

## 5. Add Lint Pipeline

- [ ] 5.1 Create `.luacheckrc` at `zsh/modules/hammerspoon/data/` with globals `hs`, `spoon`, `config`, and `std = "lua5.3"`
- [ ] 5.2 Run `luacheck .` from the data directory and fix any warnings/errors
- [ ] 5.3 Add luacheck validation step to the project's pre-commit / Taskfile validation pipeline for `zsh/modules/hammerspoon/data/**/*.lua`

## 6. Add Developer Docs

- [ ] 6.1 Add module-level comment block to `src/mod/apps/config.lua` explaining how to add new app bindings
- [ ] 6.2 Add module-level comment block to `src/mod/work/config.lua` explaining workspace profile structure
- [ ] 6.3 Add module-level comment block to `src/core/config/defaults.lua` explaining config hierarchy
- [ ] 6.4 Add commented Spoon-loading example to `custom.lua.tpl`
