## ADDED Requirements

### Requirement: Fix NVIM_FILE_SETTINGS path
The system SHALL fix the `NVIM_FILE_SETTINGS` path in `config/base.zsh` to point to the correct `lua/options.lua` instead of the non-existent `lua/config/options.lua`.

#### Scenario: Update the path
- **WHEN** fixing the zsh config
- **THEN** `NVIM_FILE_SETTINGS` SHALL be set to `"${NVIM_CONFIG_PATH}/lua/options.lua"`

#### Scenario: Path exists
- **WHEN** the new path is set
- **THEN** the file `lua/options.lua` SHALL exist at the resolved path

### Requirement: Remove NVIM_ROOT_PATH duplicate
The system SHALL remove the `NVIM_ROOT_PATH` variable from `config/base.zsh` since it duplicates `NVIM_CONFIG_PATH`.

#### Scenario: Confirm NVIM_ROOT_PATH is unused
- **WHEN** preparing to delete `NVIM_ROOT_PATH`
- **THEN** `rg "NVIM_ROOT_PATH"` SHALL only reference the definition line (no other callers)

#### Scenario: Remove the variable
- **WHEN** confirmed unused
- **THEN** the `NVIM_ROOT_PATH` definition line SHALL be removed from `config/base.zsh`
