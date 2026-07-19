# shellcheck shell=bash
# waybar module — entry point
#
# Chains: config/main.zsh → internal/main.zsh → pkg/main.zsh

[[ -n "${__ZSH_WAYBAR_LOADED:-}" ]] && return
__ZSH_WAYBAR_LOADED=1

ZSH_WAYBAR_PATH="$(dirname "${0}")"
message_info "Loading module: ${WAYBAR_PACKAGE_NAME}"

# shellcheck source=/dev/null
source "${ZSH_WAYBAR_PATH}/config/main.zsh"
$ZSH_WAYBAR_ENABLED || return

# shellcheck source=/dev/null
source "${ZSH_WAYBAR_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_WAYBAR_PATH}/pkg/main.zsh"
