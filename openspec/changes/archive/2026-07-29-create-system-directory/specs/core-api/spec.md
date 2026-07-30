## ADDED Requirements

### Requirement: All core API functions remain at same file-relative paths
The public API functions in `zsh/core/pkg/` SHALL remain at the same relative paths after the move to `zsh/system/core/pkg/`. The `core::*` and `message_*` function signatures SHALL NOT change.

#### Scenario: Core functions available after move
- **WHEN** `zsh/system/core/main.zsh` is sourced from the new location
- **THEN** `core::exists`, `core::install`, `core::ensure`, `message_info`, `message_error`, `message_warning`, `message_success` SHALL all be available
- **AND** their behavior SHALL be identical to before the move

## MODIFIED Requirements

### Requirement: Environment variable definitions
The system SHALL define `DOTFILES_CORE_PATH` pointing to the new `zsh/system/core/` directory.

**FROM:** `DOTFILES_CORE_PATH="${DOTFILES_ZSH_DIR}/core"`
**TO:** `DOTFILES_CORE_PATH="${DOTFILES_ZSH_DIR}/system/core"`

#### Scenario: DOTFILES_CORE_PATH reflects new location
- **WHEN** `zshrc` is sourced
- **THEN** `DOTFILES_CORE_PATH` SHALL equal `"${DOTFILES_ZSH_DIR}/system/core"`
