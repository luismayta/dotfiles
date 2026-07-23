## ADDED Requirements

### Requirement: Single format-on-save implementation
The system SHALL use conform.nvim as the sole format-on-save implementation.

#### Scenario: Format on save
- **WHEN** a file is saved
- **THEN** conform.nvim automatically formats it using the configured formatter for that filetype

#### Scenario: Manual format
- **WHEN** user presses `<leader>f`
- **THEN** conform.nvim formats the current buffer (or visual selection)

### Requirement: Filetype-specific formatters
The system SHALL configure formatters per filetype in conform.nvim.

#### Scenario: Lua files
- **WHEN** a `.lua` file is saved
- **THEN** it is formatted with stylua

#### Scenario: TypeScript/JavaScript files
- **WHEN** a `.ts`, `.tsx`, `.js`, `.jsx` file is saved
- **THEN** it is formatted with biome-check (or prettier)

#### Scenario: Go files
- **WHEN** a `.go` file is saved
- **THEN** it is formatted with goimports + golines

#### Scenario: Rust files
- **WHEN** a `.rs` file is saved
- **THEN** it is formatted with rustfmt

#### Scenario: Markdown files
- **WHEN** a `.md` file is saved
- **THEN** it is formatted with markdownlint-cli2 + markdown-toc (if TOC marker present)

### Requirement: LSP fallback formatting
The system SHALL fall back to LSP formatting when no conform.nvim formatter is configured for a filetype.

#### Scenario: Unconfigured filetype
- **WHEN** a file of an unconfigured filetype is saved
- **THEN** conform.nvim attempts LSP formatting as fallback

### Requirement: Format keymap
The system SHALL provide a `<leader>f` keymap to manually trigger formatting.

#### Scenario: Manual format keymap
- **WHEN** user presses `<leader>f` in normal or visual mode
- **THEN** conform.nvim formats the current buffer or visual selection
