## ADDED Requirements

### Requirement: Rust module loads on shell start
The `zsh/modules/rust/plugin.zsh` file SHALL be sourced automatically when the shell starts via the existing modules loader in `zshrc`.

#### Scenario: Module loads with rust functions available
- **WHEN** a shell starts
- **THEN** all `rust::*` functions SHALL be available in the shell

### Requirement: Idempotent loading
The module SHALL guard against double-sourcing using `__ZSH_RUST_LOADED`.

#### Scenario: Double source skipped
- **WHEN** `rust/plugin.zsh` is sourced a second time
- **THEN** it SHALL return immediately without re-executing

### Requirement: Rust toolchain auto-install
The module SHALL install Rust via rustup if `rustc` is not found and `curl` is available.

#### Scenario: Install on missing rustc
- **WHEN** `rustc` is not found and `curl` is available
- **THEN** the module SHALL run `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

### Requirement: Cargo binary PATH setup
The module SHALL add `~/.cargo/bin` to `PATH` and source `~/.cargo/env` if they exist.

#### Scenario: Cargo bin directory exists
- **WHEN** `~/.cargo/bin` exists
- **THEN** it SHALL be prepended to `PATH`

#### Scenario: Cargo env file exists
- **WHEN** `~/.cargo/env` exists
- **THEN** it SHALL be sourced

### Requirement: Cargo package manager
The module SHALL install cargo packages defined in `RUST_CARGO_PACKAGES` array using `cargo install`.

#### Scenario: Cargo package install
- **WHEN** `rust::internal::packages::install` is called
- **THEN** each package in `RUST_CARGO_PACKAGES` SHALL be installed via `cargo install`

### Requirement: Delta git pager configuration
The module SHALL configure `git-delta` as the git pager if delta is available.

#### Scenario: Delta config applied
- **WHEN** `delta` is present in PATH
- **THEN** the module SHALL set git config for `core.pager`, `interactive.diffFilter`, `delta.navigate`, and `merge.conflictStyle`

### Requirement: Zoxide shell integration
The module SHALL initialize `zoxide` for zsh if zoxide is available.

#### Scenario: Zoxide init
- **WHEN** `zoxide` is present in PATH
- **THEN** `zoxide init zsh` SHALL be evaluated

### Requirement: Cargo dependency before installs
The module SHALL verify `curl` is available before attempting rustup installation, installing it via `core::install curl` if missing.

#### Scenario: Missing curl dependency
- **WHEN** `curl` is not available before rustup install
- **THEN** it SHALL be installed first

### Requirement: Post-install hook
The module SHALL provide `rust::post_install` for post-installation setup.

#### Scenario: Post-install runs
- **WHEN** `rust::post_install` is called
- **THEN** it SHALL print success message for `RUST_PACKAGE_NAME`
