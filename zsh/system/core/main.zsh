# shellcheck shell=bash
# Core — single entry point for the core dotfiles layer
#
# Chains: config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_CORE_LOADED:-}" ]] && return
__ZSH_CORE_LOADED=1

# Module root path — backward compat for migrated scripts
# shellcheck disable=SC2034
CORE_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/config/main.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/internal/main.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/pkg/main.zsh