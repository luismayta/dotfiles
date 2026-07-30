# shellcheck shell=bash
# Nix module — single-user Nix package manager
#

[[ -n "${__ZSH_NIX_LOADED:-}" ]] && return
__ZSH_NIX_LOADED=1

# Module root path
# shellcheck disable=SC2034
ZSH_NIX_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${ZSH_NIX_PATH}"/config/main.zsh
$ZSH_NIX_ENABLED || return

# shellcheck source=/dev/null
source "${ZSH_NIX_PATH}"/internal/main.zsh

# shellcheck source=/dev/null
source "${ZSH_NIX_PATH}"/pkg/main.zsh
