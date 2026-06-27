#
# shellcheck shell=bash
# rvm ZSH module
#
# Port of hadenlabs/zsh-rvm into the modules/ convention.
# Provides rvm installation, version management, and gem package
# setup with OS-specific dispatch (macOS/Linux).
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_RVM_LOADED:-}" ]] && return
__ZSH_RVM_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_RVM_PATH="$(dirname "${0}")"
message_info "Loading module: rvm"

# shellcheck source=/dev/null
source "${ZSH_RVM_PATH}/config/main.zsh"
# enabled guard
$ZSH_RVM_ENABLED || return

# shellcheck source=/dev/null
source "${ZSH_RVM_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_RVM_PATH}/pkg/main.zsh"
