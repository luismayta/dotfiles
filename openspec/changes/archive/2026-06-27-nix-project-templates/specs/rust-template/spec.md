## ADDED Requirements

### Requirement: Rust project flake template
The system SHALL provide a Nix flake template for Rust projects under `data/templates/rust/flake.nix`.

The template SHALL include:
- `nixpkgs` input pointing to `nixpkgs-unstable`
- A `devShells.default` with: `cargo`, `rustc`, `clippy`, `rust-analyzer`, `rustfmt`
- Shell hook that sources `rust-analyzer` and sets `RUST_SRC_PATH`
- A `formatter` output pointing to `nixpkgs-fmt`

#### Scenario: Template creates devShell with Rust toolchain
- **WHEN** a user runs `nix::scaffold::new /path --lang rust`
- **THEN** the resulting `flake.nix` SHALL contain `cargo`, `rustc`, and `clippy` in `devShells.default.buildInputs`

#### Scenario: rust-analyzer is available for LSP
- **WHEN** a user enters `nix develop` in a project scaffolded with `--lang rust`
- **THEN** `rust-analyzer --version` SHALL be available in PATH

#### Scenario: Template includes rustfmt
- **WHEN** a user runs `nix develop` in a project scaffolded with `--lang rust`
- **THEN** `rustfmt --version` SHALL be available in PATH
