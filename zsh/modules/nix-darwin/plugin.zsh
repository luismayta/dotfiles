# shellcheck shell=bash
# nix-darwin ZSH module
#
# Provides helpers to manage nix-darwin system configuration on macOS:
# rebuild, update, status, and bootstrap hints.
#

[[ -n "${__ZSH_NIX_DARWIN_LOADED:-}" ]] && return
__ZSH_NIX_DARWIN_LOADED=1

# Module root path
NIX_DARWIN_PATH="${0:A:h}"

message_info "Loading module: nix-darwin"

# shellcheck source=/dev/null
source "${NIX_DARWIN_PATH}/config/main.zsh"
# enabled guard
$ZSH_NIX_DARWIN_ENABLED || return
