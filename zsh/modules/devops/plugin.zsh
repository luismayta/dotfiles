#
# shellcheck shell=bash
# Devops ZSH module
#
# Provides DevOps tooling aliases and helpers for infrastructure workflows.
#

[[ -n "${__ZSH_DEVOPS_LOADED:-}" ]] && return
__ZSH_DEVOPS_LOADED=1

DEVOPS_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${DEVOPS_PATH}/pkg/main.zsh"
