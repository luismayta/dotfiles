#
# shellcheck shell=bash
# git ZSH module
#
# Port of hadenlabs/zsh-git into the modules/ convention.
# Provides git aliases, helper functions, and CLI utilities
# for daily git workflow with OS-specific dispatch (macOS/Linux).
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_GIT_LOADED:-}" ]] && return
__ZSH_GIT_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_GIT_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/internal/main.zsh"

export PATH="${ZSH_GIT_PATH}/bin:${PATH}"

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/pkg/main.zsh"
