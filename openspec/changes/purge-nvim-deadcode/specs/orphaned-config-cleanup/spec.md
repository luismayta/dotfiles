## ADDED Requirements

### Requirement: Delete orphaned config files
The system SHALL delete config files that exist on disk but are no longer required by any plugin spec or any other file in the module.

#### Scenario: Confirm each file is unreferenced before deletion
- **WHEN** preparing to delete a config file
- **THEN** the file MUST NOT be referenced by any `require("configs.<name>")` or `require("configs.<name>")` call anywhere in the codebase

#### Scenario: Delete mason.lua
- **WHEN** the orphaned config deletion runs
- **THEN** `zsh/modules/nvim/data/lua/configs/mason.lua` SHALL be deleted

#### Scenario: Delete neoscroll.lua
- **WHEN** the orphaned config deletion runs
- **THEN** `zsh/modules/nvim/data/lua/configs/neoscroll.lua` SHALL be deleted

#### Scenario: Delete treesitter-context.lua
- **WHEN** the orphaned config deletion runs
- **THEN** `zsh/modules/nvim/data/lua/configs/treesitter-context.lua` SHALL be deleted

#### Scenario: Delete hop.lua
- **WHEN** the orphaned config deletion runs
- **THEN** `zsh/modules/nvim/data/lua/configs/hop.lua` SHALL be deleted

#### Scenario: Delete tabout.lua
- **WHEN** the orphaned config deletion runs
- **THEN** `zsh/modules/nvim/data/lua/configs/tabout.lua` SHALL be deleted

#### Scenario: Delete illuminate.lua
- **WHEN** the orphaned config deletion runs
- **THEN** `zsh/modules/nvim/data/lua/configs/illuminate.lua` SHALL be deleted

#### Scenario: Delete visual-multi.lua
- **WHEN** the orphaned config deletion runs
- **THEN** `zsh/modules/nvim/data/lua/configs/visual-multi.lua` SHALL be deleted

#### Scenario: No load errors after deletion
- **WHEN** all orphaned config files have been deleted
- **THEN** `nvim --headless -c "qa"` MUST exit with code 0
