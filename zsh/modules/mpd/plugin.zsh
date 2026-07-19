# shellcheck shell=bash
# MPD ZSH module — Music Player Daemon + mpc CLI client

[[ -n "${__ZSH_MPD_LOADED:-}" ]] && return
__ZSH_MPD_LOADED=1

# Module root path
# shellcheck disable=SC2034
ZSH_MPD_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${ZSH_MPD_PATH}"/config/main.zsh
$ZSH_MPD_ENABLED || return

# shellcheck source=/dev/null
source "${ZSH_MPD_PATH}"/internal/main.zsh

# shellcheck source=/dev/null
source "${ZSH_MPD_PATH}"/pkg/main.zsh
