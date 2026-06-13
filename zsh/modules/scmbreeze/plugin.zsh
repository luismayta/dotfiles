#
# shellcheck shell=bash
# scmbreeze ZSH module
#
# Port of luismayta/zsh-scmbreeze into the modules/ convention.
# Provides scm_breeze (SCM Breeze) installation and PATH management
# with OS-specific dispatch (macOS/Linux).
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_SCMBREEZE_LOADED:-}" ]] && return
__ZSH_SCMBREEZE_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_SCMBREEZE_PATH="$(dirname "${0}")"
message_info "Loading module: scmbreeze"

# shellcheck source=/dev/null
source "${ZSH_SCMBREEZE_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_SCMBREEZE_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_SCMBREEZE_PATH}/pkg/main.zsh"
