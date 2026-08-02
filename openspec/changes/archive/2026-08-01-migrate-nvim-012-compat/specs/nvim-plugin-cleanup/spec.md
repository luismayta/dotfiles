## MODIFIED Requirements

### Requirement: Deprecated plugin SHALL be replaced
The `lvimuser/lsp-inlayhints.nvim` plugin SHALL be replaced by the built-in `vim.lsp.inlayhints` API. The `mbbill/undotree` plugin SHALL be replaced by the built-in `:Undotree` command.

#### Scenario: lsp-inlayhints removed
- **WHEN** inspecting plugins under `data/lua/plugins/`
- **THEN** `lvimuser/lsp-inlayhints.nvim` SHALL NOT appear as a dependency

#### Scenario: undotree plugin removed
- **WHEN** inspecting `data/lua/plugins/ui/ui.lua`
- **THEN** `mbbill/undotree` SHALL NOT appear as a plugin spec

### Requirement: Disabled plugins SHALL be cleaned up
Plugin specs with `enabled = false` SHALL be either enabled, have an explanatory comment, or be removed. Plugins replaced by nvim 0.12 built-ins SHALL be removed entirely.

#### Scenario: Replaced plugins are removed
- **WHEN** a plugin has been replaced by a built-in nvim 0.12 feature
- **THEN** the plugin spec SHALL be removed (not just disabled)
- **AND** a comment SHALL NOT be left behind explaining the removal

#### Scenario: Disabled plugins have rationale
- **WHEN** a plugin spec has `enabled = false`
- **THEN** it SHALL have a comment explaining why it is disabled
