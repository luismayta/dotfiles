## MODIFIED Requirements

### Requirement: DOTFILES_CORE_PATH points to system/core
The system SHALL define `DOTFILES_CORE_PATH` pointing to `zsh/system/core/`.

#### Scenario: Variable reflects new location
- **WHEN** `zshrc` is sourced
- **THEN** `DOTFILES_CORE_PATH` SHALL equal `"${DOTFILES_ZSH_PATH}/system/core"`
