## ADDED Requirements

### Requirement: Composable on_attach generator
The system SHALL provide a `jasper.lsp.on_attach(features)` function that composes LSP attach behavior from a feature table.

#### Scenario: on_attach with keymaps feature adds LSP keymaps
- **WHEN** `jasper.lsp.on_attach({ keymaps = true })` is used as `on_attach` for an LSP server
- **THEN** standard LSP keymaps SHALL be set (gd, gr, K, `<leader>rn`, `<leader>ca`, etc.)

#### Scenario: on_attach with diagnostics feature configures diagnostic signs
- **WHEN** `jasper.lsp.on_attach({ diagnostics = true })` is used as `on_attach`
- **THEN** diagnostic signs SHALL be configured with custom icons (E, W, I, H)

#### Scenario: on_attach with formatting feature sets up format-on-save
- **WHEN** `jasper.lsp.on_attach({ formatting = true })` is used as `on_attach`
- **THEN** an autocmd SHALL be created to format the buffer on save using `vim.lsp.buf.format`

#### Scenario: on_attach with hover feature configures hover behavior
- **WHEN** `jasper.lsp.on_attach({ hover = true })` is used as `on_attach`
- **THEN** hover behavior SHALL be configured to show in a floating window with focus support

#### Scenario: Multiple features can be combined
- **WHEN** `jasper.lsp.on_attach({ keymaps = true, diagnostics = true, formatting = false })` is used
- **THEN** keymaps and diagnostics SHALL be configured but formatting SHALL NOT

### Requirement: LSP server config builder
The system SHALL provide a `jasper.lsp.server(name, opts)` function that creates standardized LSP server configurations.

#### Scenario: Server config includes on_attach and capabilities
- **WHEN** `jasper.lsp.server("gopls", { features = { keymaps = true } })` is called
- **THEN** the returned config SHALL include `name = "gopls"`, `on_attach`, and `capabilities`

#### Scenario: Server-specific options are merged
- **WHEN** `jasper.lsp.server("gopls", { settings = { gopls = { analyses = { unusedparams = true } } } })` is called
- **THEN** the settings SHALL be included in the returned server config
