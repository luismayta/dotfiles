## ADDED Requirements

### Requirement: Public API functions for system tool management

The system SHALL provide a set of public API functions in `zsh/core/pkg/base.zsh` that delegate to internal implementations for installing, loading, and checking the existence of system tools.

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

The system SHALL provide message helper functions in `zsh/core/pkg/base.zsh` that print colored output.

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

The system SHALL define environment variables in `zsh/core/config/env.zsh` for android SDK paths and backup paths.

#### Scenario: ANDROID_HOME is set

- **WHEN** `config/env.zsh` is sourced on macOS
- **THEN** `ANDROID_HOME` SHALL be set to `"${HOME}/Library/Android/sdk"`

#### Scenario: CORE_PROJECTS_BACKUP_PATH is set

- **WHEN** `config/env.zsh` is sourced
- **THEN** `CORE_PROJECTS_BACKUP_PATH` SHALL be set to `"${HOME}/backup"`