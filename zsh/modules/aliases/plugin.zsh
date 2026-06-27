#
# shellcheck shell=bash
# Aliases ZSH module
#
# Provides organized alias definitions for base tools, docker, editor, eza,
# and platform-specific commands.
#

[[ -n "${__ZSH_ALIASES_LOADED:-}" ]] && return
__ZSH_ALIASES_LOADED=1

ALIASES_PATH="$(dirname "${0}")"

message_info "Loading module: aliases"

# shellcheck source=/dev/null
source "${ALIASES_PATH}/config/main.zsh"
$ZSH_ALIASES_ENABLED || return

# shellcheck source=/dev/null
source "${ALIASES_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ALIASES_PATH}/pkg/main.zsh"
