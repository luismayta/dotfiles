## ADDED Requirements

### Requirement: Duplicate plugin declarations SHALL be consolidated
Each plugin `org/repo` SHALL be declared as a spec standalone in exactly ONE file — its category-correct location. References from other categories SHALL use only a dependency string, not a full spec redeclaration.

#### Scenario: Telescope consolidated to ui/ui.lua
- **WHEN** inspecting `ui/ui.lua`
- **THEN** `nvim-telescope/telescope.nvim` SHALL have its full spec (opts, init) there
- **WHEN** inspecting `tools/neogit.lua` and `ai/ai.lua`
- **THEN** `nvim-telescope/telescope.nvim` SHALL NOT appear as a spec with opts/init

#### Scenario: Devicons consolidated to ui/ui.lua
- **WHEN** inspecting `ui/ui.lua`
- **THEN** `nvim-tree/nvim-web-devicons` SHALL have its full spec (opts) there
- **WHEN** inspecting `ai/ai.lua`
- **THEN** `nvim-tree/nvim-web-devicons` SHALL NOT appear as a spec with opts

#### Scenario: Diffview consolidated to tools/diffview.lua
- **WHEN** inspecting `tools/diffview.lua`
- **THEN** `sindrets/diffview.nvim` SHALL have its full spec (cmd, init) there
- **WHEN** inspecting `tools/git.lua` and `tools/neogit.lua`
- **THEN** `sindrets/diffview.nvim` SHALL only appear as a string in `dependencies`

### Requirement: Plugin specs redundant with LazyVim core SHALL be removed
Plugin specs that LazyVim core already provides SHALL NOT be redeclared unless overriding behavior. Redundant declarations SHALL be removed and the unique components extracted to their own spec.

#### Scenario: Only unique sources remain
- **WHEN** inspecting `tools/completion.lua`
- **THEN** it SHALL NOT redeclare `hrsh7th/nvim-cmp`, `L3MON4D3/LuaSnip`, or any cmp-* sources that LazyVim core provides
- **WHEN** inspecting `tools/`
- **THEN** `ray-x/cmp-treesitter` SHALL have its own spec file

### Requirement: Cross-category dependencies SHALL be documented
Plugin specs that are used as dependencies by specs in other categories SHALL have a comment indicating which files depend on them.

#### Scenario: Telescope has cross-ref comment
- **WHEN** inspecting the telescope spec in `ui/ui.lua`
- **THEN** it SHALL have a comment `-- Dep of: ai/ai.lua, tools/neogit.lua`

#### Scenario: Treesitter has cross-ref comment
- **WHEN** inspecting the treesitter spec in `ui/ui.lua`
- **THEN** it SHALL have a comment listing its dependents

#### Scenario: Devicons has cross-ref comment
- **WHEN** inspecting the devicons spec in `ui/ui.lua`
- **THEN** it SHALL have a comment `-- Dep of: ai/ai.lua`

#### Scenario: Diffview has cross-ref comment
- **WHEN** inspecting `tools/diffview.lua`
- **THEN** it SHALL have a comment `-- Dep of: tools/git.lua, tools/neogit.lua`
