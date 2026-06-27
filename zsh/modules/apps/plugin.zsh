# shellcheck shell=bash
# shellcheck disable=SC1091
# apps module — desktop application management

[[ -n "${__ZSH_APPS_LOADED:-}" ]] && return
__ZSH_APPS_LOADED=1

ZSH_APPS_PATH="${0:A:h}"

source "${ZSH_APPS_PATH}/config/main.zsh"
$ZSH_APPS_ENABLED || return
source "${ZSH_APPS_PATH}/internal/main.zsh"
source "${ZSH_APPS_PATH}/pkg/main.zsh"
