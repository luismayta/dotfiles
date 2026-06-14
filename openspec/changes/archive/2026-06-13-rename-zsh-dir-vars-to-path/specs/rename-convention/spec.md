## ADDED Requirements

### Requirement: Naming convention for filesystem path variables
All exported variables holding filesystem directory paths in zsh configs SHALL use the `_PATH` suffix.

#### Scenario: Verify variable naming convention
- **WHEN** a zsh config file declares an exported variable pointing to a filesystem directory
- **THEN** the variable name SHALL end with `_PATH` (e.g., `DOTFILES_CORE_PATH`, not `DOTFILES_CORE_DIR`)
