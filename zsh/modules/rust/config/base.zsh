# shellcheck shell=bash
ZSH_RUST_ENABLED="${ZSH_RUST_ENABLED:-true}"
export RUST_CARGO_BIN="${HOME}/.cargo/bin"
export RUST_CARGO_ENV="${HOME}/.cargo/env"
export RUST_PACKAGE_NAME=rust
export RUST_INSTALL_URL_RUSTUP="https://sh.rustup.rs"
export RUST_CARGO_PACKAGES_SIMPLE=(
  bat
  fselect
  ripgrep
  du-dust
  bottom
  zellij
  typos-cli
  committed
  btop
  eza
  git-delta
  lychee
)

export RUST_CARGO_PACKAGES_LOCKED=(
  zoxide
  create-tauri-app
  "yazi-fm yazi-cli"
)

export RUST_CARGO_PACKAGES_FEATURES=(
  "nu --features=dataframe"
)

export RUST_RUSTUP_PACKAGES=(
  nightly
)
