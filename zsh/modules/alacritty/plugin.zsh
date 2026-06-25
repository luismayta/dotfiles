# shellcheck shell=bash
# Alacritty ZSH module
#
# Port of hadenlabs/zsh-alacritty into the modules/ convention.
# Provides Alacritty terminal configuration management — config sync, install,
# theme management, and config file editing.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_ALACRITTY_LOADED:-}" ]] && return
__ZSH_ALACRITTY_LOADED=1

# Module root path — used by all sourced sub-files
ALACRITTY_PATH="$(dirname "${0}")"
message_info "Loading module: alacritty"

# shellcheck source=/dev/null
source "${ALACRITTY_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${ALACRITTY_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ALACRITTY_PATH}/pkg/main.zsh"
