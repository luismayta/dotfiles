# shellcheck shell=bash
export RUST_CARGO_BIN="${HOME}/.cargo/bin"
export RUST_CARGO_ENV="${HOME}/.cargo/env"
export RUST_PACKAGE_NAME=rust
export RUST_INSTALL_URL_RUSTUP="https://sh.rustup.rs"
export RUST_INSTALL_URL_UV="https://github.com/astral-sh/uv"
export RUST_CARGO_PACKAGES=(
  bat
  fselect
  ripgrep
  du-dust
  bottom
  zellij
  typos-cli
  committed
  zoxide --locked
  nu --features=dataframe
  btop
  create-tauri-app --locked
  eza
  git-delta
  yazi-fm yazi-cli --locked
  --git "${RUST_INSTALL_URL_UV}" uv
)

export RUST_RUSTUP_PACKAGES=(
  nightly
)
