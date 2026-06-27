# shellcheck shell=bash
# Devbox module — Jetify Devbox: isolated development environments
#

[[ -n "${__ZSH_DEVBOX_LOADED:-}" ]] && return
__ZSH_DEVBOX_LOADED=1

# Module root path
# shellcheck disable=SC2034
ZSH_DEVBOX_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${ZSH_DEVBOX_PATH}"/config/main.zsh
$ZSH_DEVBOX_ENABLED || return

# shellcheck source=/dev/null
source "${ZSH_DEVBOX_PATH}"/internal/main.zsh

# shellcheck source=/dev/null
source "${ZSH_DEVBOX_PATH}"/pkg/main.zsh
