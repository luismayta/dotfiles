## ADDED Requirements

### Requirement: Telescope keymaps have single source of truth
The system SHALL define all Telescope-related keymaps exclusively in `mappings.lua` and SHALL remove the `M.telescope()` function from `jasper/keymaps.lua`.

#### Scenario: No duplicate keymap definitions
- **WHEN** inspecting `mappings.lua` and `jasper/keymaps.lua`
- **THEN** Telescope mappings (`<leader>ff`, `<leader>fg`, etc.) SHALL only appear in `mappings.lua`

#### Scenario: jasper telescope wrappers remain available
- **WHEN** calling `require("jasper.telescope").ff()`, `.fg()`, `.fb()`, etc.
- **THEN** the wrapper functions SHALL still work and invoke the correct Telescope builtins

#### Scenario: M.telescope() is removed
- **WHEN** inspecting the `jasper/keymaps.lua` module
- **THEN** the `M.telescope()` function SHALL NOT exist
