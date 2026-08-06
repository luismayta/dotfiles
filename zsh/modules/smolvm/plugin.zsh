# shellcheck shell=bash
# SMOLVM ZSH module
#
# Provides smolvm (microVM engine) installation and management.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_SMOLVM_LOADED:-}" ]] && return
__ZSH_SMOLVM_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_SMOLVM_PATH="$(dirname "${0}")"

message_info "Loading module: ${ZSH_SMOLVM_PACKAGE_NAME:-smolvm}"

# shellcheck source=/dev/null
source "${ZSH_SMOLVM_PATH}/config/main.zsh"
${ZSH_SMOLVM_ENABLED:-false} || return

# shellcheck source=/dev/null
source "${ZSH_SMOLVM_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_SMOLVM_PATH}/pkg/main.zsh"
