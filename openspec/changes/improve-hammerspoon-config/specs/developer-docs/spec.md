## ADDED Requirements

### Requirement: Module-level developer comments

Key configuration modules SHALL include header-level `---@module` or comment block explaining the config structure and how to extend it.

#### Scenario: App bindings module has docs
- **WHEN** a developer opens `src/mod/apps/config.lua` or the app hotkey bindings file
- **THEN** it SHALL contain a comment block at the top explaining how to add new app bindings (template: which table to add entries to, what fields each entry needs)

#### Scenario: Work profiles module has docs
- **WHEN** a developer opens `src/mod/work/config.lua`
- **THEN** it SHALL contain a comment block explaining the workspace profile structure and how to add a new profile

#### Scenario: Defaults module has docs
- **WHEN** a developer opens `src/core/config/defaults.lua`
- **THEN** it SHALL contain a comment block explaining the config hierarchy (global → local → custom) and which layer should define which values

### Requirement: Add-spoon guide

The custom.lua.tpl file SHALL include a commented example showing how to load and configure a new Spoon.

#### Scenario: Template shows Spoon pattern
- **WHEN** a developer opens `custom.lua.tpl`
- **THEN** it SHALL show a commented example of `hs.loadSpoon("SpoonName")` followed by `spoon.SpoonName:start()` with a brief explanation
