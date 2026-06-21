## ADDED Requirements

### Requirement: Remove Lspsaga commands from chadrc.lua
The system SHALL remove all Lspsaga-related `vim.cmd` mappings from `chadrc.lua` since Lspsaga is not installed.

#### Scenario: Remove K hover override
- **WHEN** cleaning up chadrc.lua
- **THEN** the `vim.cmd [[Lspsaga hover_doc]]` mapping for `K` SHALL be removed

#### Scenario: Remove code_action mapping
- **WHEN** cleaning up chadrc.lua
- **THEN** the `vim.cmd [[Lspsaga code_action]]` SHALL be removed

#### Scenario: Remove lsp_finder mapping
- **WHEN** cleaning up chadrc.lua
- **THEN** the `vim.cmd [[Lspsaga lsp_finder]]` SHALL be removed

#### Scenario: Remove show_line_diagnostics mapping
- **WHEN** cleaning up chadrc.lua
- **THEN** the `vim.cmd [[Lspsaga show_line_diagnostics]]` SHALL be removed

#### Scenario: Remove show_cursor_diagnostics mapping
- **WHEN** cleaning up chadrc.lua
- **THEN** the `vim.cmd [[Lspsaga show_cursor_diagnostics]]` SHALL be removed

### Requirement: Fix nvchad_ui.renamer reference
The system SHALL update the legacy `require("nvchad_ui.renamer")` to `require("nvchad.ui.renamer")` for forward compatibility.

#### Scenario: Update renamer require path
- **WHEN** cleaning up deprecated references in chadrc.lua
- **THEN** `require("nvchad_ui.renamer")` SHALL be changed to `require("nvchad.ui.renamer")`

#### Scenario: Renamer still works
- **WHEN** the require path has been updated
- **THEN** `nvim --headless -c "lua require('nvchad.ui.renamer')" -c "qa"` MUST not produce errors
