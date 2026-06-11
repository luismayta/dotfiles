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

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/main.zsh"
