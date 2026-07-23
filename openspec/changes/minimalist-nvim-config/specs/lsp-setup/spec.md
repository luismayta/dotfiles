## ADDED Requirements

### Requirement: Direct mason-lspconfig setup
The system SHALL configure LSP servers directly via mason-lspconfig, without LazyVim's LSP layer.

#### Scenario: Server installation
- **WHEN** a server is listed in mason-lspconfig's `ensure_installed`
- **THEN** mason-lspconfig automatically installs it via mason.nvim

#### Scenario: Server setup
- **WHEN** mason-lspconfig is configured
- **THEN** it automatically sets up each installed server with nvim-lspconfig

### Requirement: Explicit server list
The system SHALL maintain an explicit list of LSP servers to install and configure.

#### Scenario: Lua server
- **WHEN** the config is loaded
- **THEN** lua_ls is installed and configured

#### Scenario: TypeScript server
- **WHEN** the config is loaded
- **THEN** ts_ls (or vtsls) is installed and configured

#### Scenario: Go server
- **WHEN** the config is loaded
- **THEN** gopls is installed and configured

#### Scenario: Rust server
- **WHEN** the config is loaded
- **THEN** rust_analyzer is installed and configured

#### Scenario: Python server
- **WHEN** the config is loaded
- **THEN** pyright is installed and configured

### Requirement: Server-specific configuration
The system SHALL allow per-server configuration via nvim-lspconfig's `settings` key.

#### Scenario: Lua server settings
- **WHEN** lua_ls is set up
- **THEN** it receives settings for runtime, workspace, and diagnostics (e.g., disable `undefined-global` warnings)

#### Scenario: Additional server settings
- **WHEN** a server needs custom settings
- **THEN** they are passed via nvim-lspconfig's `settings` table in the server setup call

### Requirement: LSP keymaps
The system SHALL provide standard LSP keymaps for navigation, references, and code actions.

#### Scenario: Go to definition
- **WHEN** user presses `gd` (or `<leader>gd`)
- **THEN** vim.lsp.buf.definition() is invoked

#### Scenario: Hover documentation
- **WHEN** user presses `K`
- **THEN** vim.lsp.buf.hover() is invoked

#### Scenario: References
- **WHEN** user presses `gr` (or `<leader>gr`)
- **THEN** vim.lsp.buf.references() is invoked

#### Scenario: Code action
- **WHEN** user presses `<leader>ca`
- **THEN** vim.lsp.buf.code_action() is invoked

#### Scenario: Rename
- **WHEN** user presses `<leader>rn`
- **THEN** vim.lsp.buf.rename() is invoked

### Requirement: Inlay hints toggle
The system SHALL provide a keymap to toggle inlay hints (nvim 0.10+ built-in).

#### Scenario: Toggle inlay hints
- **WHEN** user presses `<leader>uh`
- **THEN** vim.lsp.inlayhints.enable() toggles inlay hints on/off
