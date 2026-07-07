# shellcheck shell=bash
# Yazi ZSH module
#
# Provides yazi (terminal file manager) installation, config
# synchronization, and a directory-preserving shell wrapper.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_YAZI_LOADED:-}" ]] && return
__ZSH_YAZI_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_YAZI_PATH="$(dirname "${0}")"

message_info "Loading module: ${ZSH_YAZI_PACKAGE_NAME:-yazi}"

# shellcheck source=/dev/null
source "${ZSH_YAZI_PATH}/config/main.zsh"
${ZSH_YAZI_ENABLED:-false} || return

# shellcheck source=/dev/null
source "${ZSH_YAZI_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_YAZI_PATH}/pkg/main.zsh"
