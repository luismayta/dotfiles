#
# shellcheck shell=bash
# Brew ZSH module
#
# Port of luismayta/zsh-brew into the modules/ convention.
# Provides Homebrew installation, PATH management, and post-install
# package setup with OS-specific dispatch (macOS/Linux).
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_BREW_LOADED:-}" ]] && return
__ZSH_BREW_LOADED=1

# Module root path — used by all sourced sub-files
BREW_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${BREW_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${BREW_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${BREW_PATH}/pkg/main.zsh"
