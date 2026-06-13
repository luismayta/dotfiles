#
# shellcheck shell=bash
# Rust ZSH module
#
# Port of luismayta/zsh-rust into the modules/ convention.
# Provides Rust toolchain management, cargo package installation,
# delta git pager config, zoxide init, and PATH/env setup.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_RUST_LOADED:-}" ]] && return
__ZSH_RUST_LOADED=1

# Module root path — used by all sourced sub-files
RUST_PATH="$(dirname "${0}")"
message_info "Loading module: rust"

# shellcheck source=/dev/null
source "${RUST_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${RUST_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${RUST_PATH}/pkg/main.zsh"
