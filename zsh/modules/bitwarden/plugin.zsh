# shellcheck shell=bash
# Bitwarden ZSH module
#
# Port of hadenlabs/zsh-bitwarden into the modules/ convention.
# Provides fzf-based Bitwarden vault item search and clipboard copy.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_BITWARDEN_LOADED:-}" ]] && return
__ZSH_BITWARDEN_LOADED=1

# Module root path
BITWARDEN_PATH="$(dirname "${0}")"
message_info "Loading module: bitwarden"

# shellcheck source=/dev/null
source "${BITWARDEN_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${BITWARDEN_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${BITWARDEN_PATH}/pkg/main.zsh"

# shellcheck source=/dev/null
source "${BITWARDEN_PATH}/keybindings.zsh"
