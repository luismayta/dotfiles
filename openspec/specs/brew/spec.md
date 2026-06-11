## ADDED Requirements

### Requirement: Brew module loads on shell start
The `zsh/modules/brew/plugin.zsh` file SHALL be sourced automatically when the shell starts via the existing modules loader in `zshrc`.

#### Scenario: Module loads with brew functions available
- **WHEN** a shell starts
- **THEN** all `brew::*` functions SHALL be available in the shell

### Requirement: Idempotent loading
The module SHALL guard against double-sourcing using `__ZSH_BREW_LOADED`.

#### Scenario: Double source skipped
- **WHEN** `brew/plugin.zsh` is sourced a second time
- **THEN** it SHALL return immediately without re-executing

### Requirement: Brew installation on macOS
The module SHALL provide `brew::install` which calls `brew::install::osx` on macOS.

#### Scenario: macOS brew install
- **WHEN** `brew::install::osx` is called on macOS
- **THEN** it SHALL run `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

### Requirement: Dependency checking before install
The module SHALL verify that `ruby` is available before attempting brew installation.

#### Scenario: Missing ruby dependency
- **WHEN** `brew::dependences::checked` is called and ruby is not installed
- **THEN** it SHALL print an error message instructing the user to install ruby with rvm

### Requirement: Post-install package setup
The module SHALL provide `brew::post_install` to install additional packages after brew is available.

#### Scenario: Post-install on macOS
- **WHEN** `brew::post_install` runs on macOS
- **THEN** it SHALL install `jq`, `the_silver_searcher`, and `tree` via brew

### Requirement: Auto-install when brew not found
The module SHALL automatically install brew when not found, running `brew::install` followed by `brew::post_install`.

#### Scenario: Auto-install triggers on missing brew
- **WHEN** the module is sourced and brew is not in PATH
- **THEN** it SHALL run `brew::install` and `brew::post_install` automatically