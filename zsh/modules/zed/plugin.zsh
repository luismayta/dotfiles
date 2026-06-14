# shellcheck shell=bash
# zed module — entry point
#
# Chains: config/main.zsh → internal/main.zsh → pkg/main.zsh

[[ -n "${__ZSH_ZED_LOADED:-}" ]] && return
__ZSH_ZED_LOADED=1

ZED_PATH="$(dirname "${0}")"
message_info "Loading module: zed"

# shellcheck source=/dev/null
source "${ZED_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${ZED_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZED_PATH}/pkg/main.zsh"
