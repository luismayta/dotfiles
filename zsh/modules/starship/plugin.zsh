#
# shellcheck shell=bash
# starship ZSH module
#
# Port of hadenlabs/zsh-starship into the modules/ convention.
# Provides starship (cross-shell prompt) installation, configuration,
# and prompt initialization with OS-specific dispatch (macOS/Linux).
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Rsync guard — ensure rsync is available for data directory operations
if ! core::exists rsync; then
    core::install rsync
fi

# Idempotency guard
[[ -n "${__ZSH_STARSHIP_LOADED:-}" ]] && return
__ZSH_STARSHIP_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_STARSHIP_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${ZSH_STARSHIP_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_STARSHIP_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_STARSHIP_PATH}/pkg/main.zsh"
