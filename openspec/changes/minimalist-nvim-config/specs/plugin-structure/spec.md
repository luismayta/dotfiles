## ADDED Requirements

### Requirement: Flat plugin directory structure
The system SHALL organize plugins in a flat `lua/plugins/` directory with one file per plugin or plugin group.

#### Scenario: Plugin file organization
- **WHEN** a developer looks at `lua/plugins/` directory
- **THEN** they see one `.lua` file per plugin (e.g., `telescope.lua`, `lsp.lua`, `catppuccin.lua`)

#### Scenario: Plugin file naming
- **WHEN** a plugin file is created
- **THEN** it SHALL be named after the primary plugin it configures (e.g., `telescope.lua` for telescope.nvim)

#### Scenario: Plugin group files
- **WHEN** multiple small plugins are closely related (e.g., mini.nvim modules)
- **THEN** they MAY be grouped in a single file (e.g., `mini.lua`)

### Requirement: Plugin files return lazy.nvim spec tables
Each plugin file SHALL return a lazy.nvim plugin specification table or array of tables.

#### Scenario: Single plugin file
- **WHEN** a plugin file configures one plugin
- **THEN** it returns a single spec table with `opts`, `config`, `keys`, etc.

#### Scenario: Multiple plugin file
- **WHEN** a plugin file configures multiple related plugins
- **THEN** it returns an array of spec tables

### Requirement: No nested plugin directories
The system SHALL NOT use nested directories under `lua/plugins/` (e.g., no `plugins/lsp/`, `plugins/editor/`).

#### Scenario: Flat structure enforcement
- **WHEN** a developer runs `ls lua/plugins/`
- **THEN** all entries are `.lua` files, not directories (except possibly `after/` for special cases)

### Requirement: Plugin import manifest
The system SHALL have a single entry point that imports all plugin files via `{ import = "plugins" }`.

#### Scenario: Lazy.nvim setup
- **WHEN** lazy.nvim is configured in `config/lazy.lua`
- **THEN** it uses `{ import = "plugins" }` to auto-discover all files in `lua/plugins/`
