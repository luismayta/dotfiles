# shellcheck shell=bash
# Hammerspoon ZSH module
#
# Provides hammerspoon configuration management — config sync, install,
# and config file management.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_HAMMERSPOON_LOADED:-}" ]] && return
__ZSH_HAMMERSPOON_LOADED=1

# Module root path — used by all sourced sub-files
HAMMERSPOON_PATH="${0:A:h}"

message_info "Loading module: hammerspoon"

# shellcheck source=/dev/null
source "${HAMMERSPOON_PATH}/config/main.zsh"
# enabled guard
$ZSH_HAMMERSPOON_ENABLED || return

# shellcheck source=/dev/null
source "${HAMMERSPOON_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${HAMMERSPOON_PATH}/pkg/main.zsh"
