## MODIFIED Requirements

### Requirement: Mason configuration SHALL use correct schema

The `chadrc.lua` Mason configuration SHALL use the NvChad v2.5 correct schema: `M.mason.ensure_installed` instead of `M.mason.pkgs`.

**Note**: This requirement is unchanged from the base spec. Implementation already satisfies it.

#### Scenario: Mason pkgs key is corrected
- **WHEN** `chadrc.lua` is evaluated
- **THEN** `M.mason` SHALL contain `ensure_installed` key
- **AND** `M.mason` SHALL NOT contain `pkgs` key

### Requirement: Mason SHALL NOT manage LSP server configuration

Mason SHALL only handle tool installation (installing binaries to `~/.local/share/nvim/mason`). LSP server configuration SHALL be managed exclusively via `vim.lsp.config()` + `vim.lsp.enable()` in `configs/lspconfig.lua`. The `mason-lspconfig.nvim` plugin SHALL NOT be used.

#### Scenario: mason-lspconfig is removed
- **WHEN** `plugins/spec/lsp/mason.lua` is evaluated
- **THEN** there SHALL be no `require("mason-lspconfig")` call
- **AND** there SHALL be no `"williamboman/mason-lspconfig.nvim"` entry in the plugin spec

#### Scenario: Mason UI has proper border
- **WHEN** `:Mason` command is executed
- **THEN** the Mason UI SHALL render with rounded borders
- **AND** no errors SHALL appear in Mason logs

#### Scenario: No `ensure_installed` for LSP servers in Mason
- **WHEN** `mason.lua` or `mason.setup()` opts are evaluated
- **THEN** there SHALL be no LSP server names listed in any `ensure_installed` key under `mason.nvim` configuration
- **AND** all LSP servers SHALL be listed in `configs/lspconfig.lua`

## REMOVED Requirements

### Requirement: Mason ensure_installed lists SHALL be deduplicated

**Reason**: Mason no longer has an `ensure_installed` list for LSP servers. The deduplication concern now lives in `mason-tool-installer.nvim` (for non-LSP tools) and `configs/lspconfig.lua` (for LSP servers). There is a single source of truth per concern.

**Migration**: LSP servers are listed only in `configs/lspconfig.lua`. Non-LSP tools are listed only in `mason-tool-installer.nvim`'s `ensure_installed`. No cross-file deduplication is needed.
