## ADDED Requirements

### Requirement: rustup install URL declared in config
The rust module SHALL declare its rustup install URL as `RUST_INSTALL_URL_RUSTUP` in `config/base.zsh`.

#### Scenario: Variable is defined
- **WHEN** inspecting `zsh/modules/rust/config/base.zsh`
- **THEN** `export RUST_INSTALL_URL_RUSTUP` SHALL be defined with value `https://sh.rustup.rs`

#### Scenario: Internal references variable
- **WHEN** inspecting `zsh/modules/rust/internal/base.zsh`
- **THEN** the rustup install command SHALL use `${RUST_INSTALL_URL_RUSTUP}`
- **AND** SHALL NOT contain a hardcoded `https://sh.rustup.rs` URL

### Requirement: cargo uv install URL declared in config
The rust module SHALL declare its UV (cargo) install URL as `RUST_INSTALL_URL_UV` in `config/base.zsh`.

#### Scenario: Cargo git URL is defined
- **WHEN** inspecting `zsh/modules/rust/config/base.zsh`
- **THEN** `export RUST_INSTALL_URL_UV` SHALL be defined with value `https://github.com/astral-sh/uv`

#### Scenario: Internal references cargo variable
- **WHEN** inspecting `zsh/modules/rust/config/base.zsh`
- **THEN** the cargo install command SHALL reference `${RUST_INSTALL_URL_UV}`
- **AND** SHALL NOT contain a hardcoded `https://github.com/astral-sh/uv` URL