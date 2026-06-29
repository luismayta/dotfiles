## ADDED Requirements

### Requirement: custom.lua generated from template

The system SHALL generate `custom.lua` from a template file (`custom.lua.tpl`) during the `hammerspoon::setup` phase, but only if the target file does not already exist.

#### Scenario: First-time setup creates custom.lua
- **WHEN** `hammerspoon::setup` runs and `~/.hammerspoon/custom.lua` does not exist
- **THEN** the system SHALL copy `custom.lua.tpl` to `~/.hammerspoon/custom.lua`

#### Scenario: Existing custom.lua is preserved
- **WHEN** `hammerspoon::setup` runs and `~/.hammerspoon/custom.lua` already exists
- **THEN** the system SHALL NOT overwrite the existing file

#### Scenario: Sync overrides generated config
- **WHEN** `hammerspoon::sync` runs after setup
- **THEN** the `rsync` SHALL overwrite `~/.hammerspoon/custom.lua` with the version from the repo (the template is never a user-override target, but if the synced file has changes they propagate normally)

### Requirement: Template file with placeholder values

`custom.lua.tpl` SHALL contain documented placeholder values for configurable settings (app launchers, key bindings, workspace profiles) with comments explaining each field.

#### Scenario: Template is self-documenting
- **WHEN** a developer opens `custom.lua.tpl`
- **THEN** each configurable field SHALL have a `---@field` comment or inline comment describing its purpose and expected value type

#### Scenario: Template does not reference non-existent modules
- **WHEN** the template is loaded by the config loader
- **THEN** all `require()` calls in the template SHALL reference modules that exist in the data directory
