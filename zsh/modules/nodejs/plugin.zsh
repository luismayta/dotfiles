#
# shellcheck shell=bash
# Node.js ZSH module
#
# Port of hadenlabs/zsh-fnm into the modules/ convention.
# Provides Node.js toolchain management: fnm installation, PATH management,
# and Node.js version setup with OS-specific dispatch (macOS/Linux).
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_NODEJS_LOADED:-}" ]] && return
__ZSH_NODEJS_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_NODEJS_PATH="$(dirname "${0}")"
message_info "Loading module: nodejs"

# shellcheck source=/dev/null
source "${ZSH_NODEJS_PATH}/config/main.zsh"
$ZSH_NODEJS_ENABLED || return

# shellcheck source=/dev/null
source "${ZSH_NODEJS_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_NODEJS_PATH}/pkg/main.zsh"
