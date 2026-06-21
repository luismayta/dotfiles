# nvim-mason-setup Specification

## Purpose
TBD - created by archiving change fix-nvim-config-quality. Update Purpose after archive.
## Requirements
### Requirement: Mason configuration SHALL use correct schema
The `chadrc.lua` Mason configuration SHALL use the NvChad v2.5 correct schema: `M.mason.ensure_installed` instead of `M.mason.pkgs`.

#### Scenario: Mason pkgs key is corrected
- **WHEN** `chadrc.lua` is evaluated
- **THEN** `M.mason` SHALL contain `ensure_installed` key
- **AND** `M.mason` SHALL NOT contain `pkgs` key

### Requirement: Mason ensure_installed lists SHALL be deduplicated
Packages listed in `ensure_installed` across `mason.lua`, `mason-lspconfig.lua`, and `chadrc.lua` SHALL not duplicate each other.

#### Scenario: No duplicate packages
- **WHEN** comparing `ensure_installed` across all config files
- **THEN** each package SHALL appear in exactly one list

