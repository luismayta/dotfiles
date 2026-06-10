#
# shellcheck shell=bash
# fnm ZSH module
#
# Port of hadenlabs/zsh-fnm into the modules/ convention.
# Provides fnm (Fast Node Manager) installation, PATH management,
# and Node.js version setup with OS-specific dispatch (macOS/Linux).
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_FNM_LOADED:-}" ]] && return
__ZSH_FNM_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_FNM_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${ZSH_FNM_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_FNM_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_FNM_PATH}/pkg/main.zsh"
