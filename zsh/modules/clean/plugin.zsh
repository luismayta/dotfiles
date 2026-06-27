#
# shellcheck shell=bash
# Clean ZSH module
#
# Provides cleanup and housekeeping utilities for terminal sessions.
#

[[ -n "${__ZSH_CLEAN_LOADED:-}" ]] && return
__ZSH_CLEAN_LOADED=1

CLEAN_PATH="$(dirname "${0}")"
message_info "Loading module: clean"

# shellcheck source=/dev/null
source "${CLEAN_PATH}/config/main.zsh"
$ZSH_CLEAN_ENABLED || return

# shellcheck source=/dev/null
source "${CLEAN_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${CLEAN_PATH}/pkg/main.zsh"
