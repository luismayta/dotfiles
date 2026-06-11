## ADDED Requirements

### Requirement: Dotfiles core system loads correctly
The zshrc SHALL source `zsh/core/main.zsh` via `DOTFILES_CORE_DIR` environment variable. The core system SHALL be available before any plugin or module loads.

#### Scenario: Core is sourced from correct directory
- **WHEN** `zsh/zshrc` is sourced
- **THEN** it SHALL source `${DOTFILES_CORE_DIR}/main.zsh` where `DOTFILES_CORE_DIR="${DOTFILES_ZSH_DIR}/core"`
- **AND** `DOTFILES_MOD_DIR` SHALL be exported as a backward-compatible alias for `DOTFILES_CORE_DIR`

### Requirement: path::clean detection uses zsh function syntax
The zshrc SHALL use `(( $+functions[path::clean] ))` to detect if the `path::clean` function is loaded, instead of `type -p`.

#### Scenario: path::clean detected after core loads
- **WHEN** `zsh/core/main.zsh` has been sourced
- **THEN** `(( $+functions[path::clean] ))` SHALL return true

#### Scenario: FPATH is cleaned, not PATH
- **WHEN** `zsh/zshrc` cleans the function search path
- **THEN** it SHALL use `path::clean "${FPATH}"` (not `"${PATH}"`) to deduplicate `FPATH`

### Requirement: CUSTOMRC fallback defined in zshrc
The zshrc SHALL provide a fallback for `CUSTOMRC` if the variable is not yet set when it is referenced.

#### Scenario: CUSTOMRC fallback exists
- **WHEN** `$CUSTOMRC` is referenced in `zsh/zshrc` before core has loaded
- **THEN** the expression `${CUSTOMRC:-${HOME}/.customrc}` SHALL be used

### Requirement: Completions initialize on all platforms
The zshrc SHALL initialize `compinit` on both macOS and Linux.

#### Scenario: compinit runs on Linux
- **WHEN** `zsh/zshrc` is sourced on a Linux system
- **THEN** `autoload -Uz compinit && compinit` SHALL execute

### Requirement: Shebang is zsh
The `zsh/zshrc` file SHALL use `#!/usr/bin/env zsh` as its shebang.

#### Scenario: File starts with correct shebang
- **WHEN** the first line of `zsh/zshrc` is read
- **THEN** it SHALL equal `#!/usr/bin/env zsh`
