## ADDED Requirements

### Requirement: Remove duplicate telescope mappings from spec/ui/ui.lua
The system SHALL remove telescope key mappings from `spec/ui/ui.lua` since they are now defined in `mappings.lua` via jasper.telescope wrappers.

#### Scenario: Remove find_files mapping
- **WHEN** cleaning up duplicate telescope mappings
- **THEN** the `<leader>ff` mapping SHALL be removed from `spec/ui/ui.lua`

#### Scenario: Remove buffers mapping
- **WHEN** cleaning up duplicate telescope mappings
- **THEN** the `<leader>fb` mapping SHALL be removed from `spec/ui/ui.lua`

#### Scenario: Remove oldfiles mapping
- **WHEN** cleaning up duplicate telescope mappings
- **THEN** the `<leader>fo` mapping SHALL be removed from `spec/ui/ui.lua`

#### Scenario: Remove live_grep mapping
- **WHEN** cleaning up duplicate telescope mappings
- **THEN** the `<leader>fw` mapping SHALL be removed from `spec/ui/ui.lua`

#### Scenario: Remove conflicting mappings completely
- **WHEN** a mapping in `spec/ui/ui.lua` has different behavior than the one in `mappings.lua` (e.g., `<leader>fr`, `<leader>fh`)
- **THEN** the mapping SHALL be removed from `spec/ui/ui.lua` to eliminate the conflict

### Requirement: Remove colorify mapping from mappings.lua
The system SHALL remove the `colorify` mapping from `mappings.lua` since the plugin is not installed.

#### Scenario: Remove <C-Up> and <C-Down> colorify mappings
- **WHEN** cleaning up dead keymaps
- **THEN** the `<C-Up>` and `<C-Down>` mappings that reference `colorify.tools` SHALL be removed from `mappings.lua`

#### Scenario: No colorify references remain
- **WHEN** the mappings are removed
- **THEN** `rg "colorify"` in the nvim data directory SHALL return zero results
