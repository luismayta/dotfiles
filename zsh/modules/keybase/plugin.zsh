# shellcheck shell=bash
# keybase module

[[ -n "${__ZSH_KEYBASE_LOADED:-}" ]] && return
__ZSH_KEYBASE_LOADED=1

ZSH_KEYBASE_PATH="${0:A:h}"

source "${ZSH_KEYBASE_PATH}/config/main.zsh"
$ZSH_KEYBASE_ENABLED || return
source "${ZSH_KEYBASE_PATH}/internal/main.zsh"
source "${ZSH_KEYBASE_PATH}/pkg/main.zsh"
