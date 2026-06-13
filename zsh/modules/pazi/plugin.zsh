#
# shellcheck shell=bash
# Pazi ZSH module
#
# Provides fast directory navigation via fuzzy matching with pazi.
#

[[ -n "${__ZSH_PAZI_LOADED:-}" ]] && return
__ZSH_PAZI_LOADED=1

PAZI_PATH="$(dirname "${0}")"
message_info "Loading module: pazi"

# shellcheck source=/dev/null
source "${PAZI_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${PAZI_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${PAZI_PATH}/pkg/main.zsh"
