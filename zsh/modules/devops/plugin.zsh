#
# shellcheck shell=bash
# Devops ZSH module
#
# Provides DevOps tooling aliases and helpers for infrastructure workflows.
#

# Rsync guard — ensure rsync is available for data directory operations
if ! core::exists rsync; then
    core::install rsync
fi

[[ -n "${__ZSH_DEVOPS_LOADED:-}" ]] && return
__ZSH_DEVOPS_LOADED=1

DEVOPS_PATH="$(dirname "${0}")"
message_info "Loading module: devops"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/config/main.zsh"
$ZSH_DEVOPS_ENABLED || return

# Registered ahead of the system site-functions so compinit picks up the
# #compdef header and any _gcloud autoload resolves to this file, not the
# SDK's completion.zsh.inc symlink.
# shellcheck disable=SC2206 # zsh array assignment not supported by shellcheck
[[ -d "${DEVOPS_PATH}/data/completions" ]] && fpath=("${DEVOPS_PATH}/data/completions" $fpath)

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/main.zsh"
