# shellcheck shell=bash
# Templates ZSH module
#
# Port of hadenlabs/zsh-templates into the modules/ convention.
# Provides fzf-based template loading and clipboard copy.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_TEMPLATES_LOADED:-}" ]] && return
__ZSH_TEMPLATES_LOADED=1

# Module root path — used by all sourced sub-files
TEMPLATES_PATH="$(dirname "${0}")"
message_info "Loading module: templates"

# shellcheck source=/dev/null
source "${TEMPLATES_PATH}/config/main.zsh"
# enabled guard
$ZSH_TEMPLATES_ENABLED || return

# shellcheck source=/dev/null
source "${TEMPLATES_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${TEMPLATES_PATH}/pkg/main.zsh"

# shellcheck source=/dev/null
source "${TEMPLATES_PATH}/keybindings.zsh"
