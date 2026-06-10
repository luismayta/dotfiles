## ADDED Requirements

### Requirement: Modules directory structure
The `zsh/modules/` directory SHALL contain subdirectories, each representing a ZSH module. Each module SHALL have a `plugin.zsh` entry point.

#### Scenario: Module loads successfully
- **WHEN** `zsh/modules/zsh-brew/plugin.zsh` exists
- **THEN** it SHALL be sourced when the shell starts

### Requirement: Module loader in zshrc
The `zsh/zshrc` file SHALL source all `modules/*/plugin.zsh` files in alphabetical order after loading `mod/main.zsh`.

#### Scenario: Modules load after core
- **WHEN** zshrc executes
- **THEN** `mod/main.zsh` loads before any `modules/*/plugin.zsh`

### Requirement: Graceful missing modules
If a module directory exists but has no `plugin.zsh`, the loader SHALL skip it with a warning.

#### Scenario: Missing plugin.zsh skipped
- **WHEN** a module directory has no `plugin.zsh`
- **THEN** a warning is printed and loading continues