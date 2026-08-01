## ADDED Requirements

### Requirement: Public API functions for system tool management

The system SHALL provide a set of public API functions in `zsh/system/core/pkg/base.zsh` that delegate to internal implementations for installing, loading, and checking the existence of system tools.

#### Scenario: core::exists returns true for installed tool

- **WHEN** `core::exists bat` is called and `bat` is available in `PATH`
- **THEN** the function SHALL return 0 (success)

#### Scenario: core::install delegates to brew

- **WHEN** `core::install ripgrep` is called
- **THEN** the function SHALL delegate to `brew install ripgrep`

#### Scenario: core::load prints not-implemented warning

- **WHEN** `core::load` is called
- **THEN** the function SHALL print `"Method not implemented for core"`

### Requirement: Message helper functions

The system SHALL provide message helper functions in `zsh/system/core/pkg/base.zsh` that print colored output.

#### Scenario: message_info prints green info

- **WHEN** `message_info "hello"` is called
- **THEN** `[INFO]: hello` SHALL be printed in bold green

#### Scenario: message_error prints red error

- **WHEN** `message_error "fail"` is called
- **THEN** `[ERROR]: fail` SHALL be printed in red

#### Scenario: message_warning prints yellow warning

- **WHEN** `message_warning "caution"` is called
- **THEN** `[WARNING]: caution` SHALL be printed in yellow

#### Scenario: message_success prints green success

- **WHEN** `message_success "done"` is called
- **THEN** `[SUCCESS]: done` SHALL be printed in green

### Requirement: Cargo-based tool installation

The system SHALL provide `core::cargo::install` to install Rust-based tools.

#### Scenario: core::cargo::install installs via cargo

- **WHEN** `core::cargo::install eza` is called
- **THEN** the function SHALL delegate to `cargo install eza`

### Requirement: Environment variable definitions

The system SHALL define environment variables in `zsh/system/core/config/env.zsh` for android SDK paths, backup paths, and the `DOTFILES_CORE_PATH` location.

#### Scenario: ANDROID_HOME is set

- **WHEN** `config/env.zsh` is sourced on macOS
- **THEN** `ANDROID_HOME` SHALL be set to `"${HOME}/Library/Android/sdk"`

#### Scenario: CORE_PROJECTS_BACKUP_PATH is set

- **WHEN** `config/env.zsh` is sourced
- **THEN** `CORE_PROJECTS_BACKUP_PATH` SHALL be set to `"${HOME}/backup"`

### Requirement: fd auto-install in core

The `zsh/system/core/pkg/helper/core.zsh` SHALL auto-install `fd` via `core::install fd` if not already present, since `fd` is used by `FZF_CTRL_T_COMMAND`, `fa`, and `fo` functions.

#### Scenario: fd auto-install on macOS
- **WHEN** `zsh/system/core/pkg/helper/core.zsh` loads on macOS and `fd` is not installed
- **THEN** `core::exists fd` returns false
- **AND** `core::install fd` is invoked, which runs `brew install fd`

#### Scenario: fd auto-install on Linux
- **WHEN** `zsh/system/core/pkg/helper/core.zsh` loads on Linux (CachyOS/Arch) and `fd` is not installed
- **THEN** `core::exists fd` returns false
- **AND** `core::install fd` is invoked, which runs `paru -S --noconfirm fd`

### Requirement: Core API functions survive relocation
All public API functions in `zsh/system/core/pkg/` SHALL remain at the same relative paths after the move to `zsh/system/`. The `core::*` and `message_*` function signatures SHALL NOT change.

#### Scenario: Core functions available from new location
- **WHEN** `zsh/system/core/main.zsh` is sourced from `zsh/system/core/`
- **THEN** `core::exists`, `core::install`, `core::ensure`, `message_info`, `message_error`, `message_warning`, `message_success` SHALL all be available
- **AND** their behavior SHALL be identical to before the move

### Requirement: DOTFILES_CORE_PATH points to system/core
The system SHALL define `DOTFILES_CORE_PATH` pointing to `zsh/system/core/`.

#### Scenario: Variable reflects new location
- **WHEN** `zshrc` is sourced
- **THEN** `DOTFILES_CORE_PATH` SHALL equal `"${DOTFILES_ZSH_PATH}/system/core"`