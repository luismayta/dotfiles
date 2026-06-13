# shellcheck shell=bash
# Ghostty ZSH module
#
# Port of hadenlabs/zsh-ghostty into the modules/ convention.
# Provides Ghostty terminal configuration management — config sync, install,
# theme management, and config file editing.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_GHOSTTY_LOADED:-}" ]] && return
__ZSH_GHOSTTY_LOADED=1

# Module root path — used by all sourced sub-files
GHOSTTY_PATH="$(dirname "${0}")"
message_info "Loading module: ghostty"

# shellcheck source=/dev/null
source "${GHOSTTY_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${GHOSTTY_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${GHOSTTY_PATH}/pkg/main.zsh"
