## ADDED Requirements

### Requirement: Config schema validation on load

The config loader SHALL validate the merged configuration against the schema defined in `core/config/schema.lua` before returning it to consumers.

#### Scenario: Valid config passes validation
- **WHEN** all config fields match the expected types defined in schema.lua
- **THEN** the loader SHALL return the config object without error

#### Scenario: Invalid config triggers warning
- **WHEN** a config field does not match the expected type (e.g. `hotkeys.enabled` is a string instead of boolean)
- **THEN** the loader SHALL print a warning via `hs.logger` with the validation error message, but SHALL NOT block Hammerspoon from loading

#### Scenario: Missing optional fields are ignored
- **WHEN** an optional config section (e.g. `displays`, `hotkeys`) is absent
- **THEN** the validation SHALL skip that section without error

#### Scenario: Browser policy references unknown browser
- **WHEN** a `browserPolicy` entry references a browser key not present in `browsers`
- **THEN** the validation SHALL print a warning with the exact name of the missing browser key

### Requirement: Validation runs after config merge

The validation SHALL execute after all config layers (global, local, custom) are merged, not on individual layers.

#### Scenario: Cross-layer reference is validated
- **WHEN** `global.lua` defines `browsers` and `custom.lua` defines `browserPolicy` that references a browser from `global.lua`
- **THEN** the validation SHALL check the merged result and pass if all references resolve
