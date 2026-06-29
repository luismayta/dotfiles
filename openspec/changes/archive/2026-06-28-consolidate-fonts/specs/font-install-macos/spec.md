## ADDED Requirements

### Requirement: Fonts installed via Homebrew casks on macOS
Los 3 nerd fonts SHALL instalarse via `brew install --cask` en macOS cuando se ejecute `core::internal::packages::install`.

#### Scenario: macOS package install includes font casks
- **WHEN** `core::internal::packages::install` runs on macOS
- **THEN** los fonts `font-fira-code-nerd-font`, `font-jetbrains-mono-nerd-font`, y `font-source-code-pro-nerd-font` SHALL instalarse via `brew install --cask`

### Requirement: CORE_CASK_PACKAGES variable
La variable `CORE_CASK_PACKAGES` SHALL definirse en `zsh/core/config/osx.zsh` con los 3 fonts nerd.

#### Scenario: CORE_CASK_PACKAGES contains 3 fonts
- **WHEN** `zsh/core/config/osx.zsh` es sourced
- **THEN** `CORE_CASK_PACKAGES` SHALL contener exactamente 3 entradas: `font-fira-code-nerd-font`, `font-jetbrains-mono-nerd-font`, `font-source-code-pro-nerd-font`
