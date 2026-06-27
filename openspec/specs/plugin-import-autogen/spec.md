## ADDED Requirements

### Requirement: Auto-generated plugin imports
The system SHALL provide a script to auto-generate `plugins/init.lua` by scanning plugin spec and override directories.

#### Scenario: Script scans spec directory for Lua files
- **WHEN** the auto-import script is executed
- **THEN** it SHALL scan `plugins/spec/` recursively for all `*.lua` files
- **THEN** it SHALL scan `plugins/override/` recursively for all `*.lua` files

#### Scenario: Generated init.lua requires all discovered plugins
- **WHEN** the script generates `plugins/init.lua`
- **THEN** the file SHALL contain `require` statements for each discovered plugin file in the correct path format

#### Scenario: Generated file has proper lazy.nvim return format
- **WHEN** the script generates `plugins/init.lua`
- **THEN** the file SHALL return a table of plugin specs compatible with lazy.nvim's `{import = "plugins.spec"}` pattern

#### Scenario: Script is safe to run from Neovim or CLI
- **WHEN** the script is run via `nvim --headless -c "luafile scripts/update-lazy-imports.lua" -c "q"`
- **THEN** it SHALL generate the `plugins/init.lua` file and exit without errors

#### Scenario: Script validates each plugin file returns a table
- **WHEN** a `.lua` file in `plugins/spec/` does not return a table
- **THEN** the script SHALL skip that file and print a warning
