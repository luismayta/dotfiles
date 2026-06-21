## ADDED Requirements

### Requirement: M.setup() is not auto-executed at require time
The `jasper/keymaps.lua` module SHALL NOT call `M.setup()` at the module level. The function SHALL remain defined but SHALL require explicit invocation.

#### Scenario: require() does not register keymaps
- **WHEN** doing `require("jasper.keymaps")`
- **THEN** no keymaps SHALL be registered as a side effect

#### Scenario: Explicit setup() registers keymaps
- **WHEN** calling `require("jasper.keymaps").setup()`
- **THEN** all defined keymaps SHALL be registered

### Requirement: Dead code is removed
The `setup_hover()` function in `jasper/lsp.lua` SHALL be removed, and `vim.o.mousemoveevent = true` SHALL be set in `options.lua` instead.

#### Scenario: No setup_hover function exists
- **WHEN** inspecting `jasper/lsp.lua`
- **THEN** the `setup_hover` function SHALL NOT exist

#### Scenario: mousemoveevent is set from options.lua
- **WHEN** nvim starts
- **THEN** `vim.o.mousemoveevent` SHALL be `true`

### Requirement: Empty keymap is removed
The `<leader>cs` mapping with an empty command in `mappings.lua` SHALL be removed.

#### Scenario: No leader-cs mapping exists
- **WHEN** inspecting `mappings.lua`
- **THEN** there SHALL be no mapping with `"<leader>cs"` as the lhs
