# shellcheck shell=bash
# Wezterm ZSH module
#
# Provides wezterm terminal configuration management — config sync, install,
# and config file editing.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_WEZTERM_LOADED:-}" ]] && return
__ZSH_WEZTERM_LOADED=1

# Module root path — used by all sourced sub-files
WEZTERM_PATH="${0:A:h}"

message_info "Loading module: wezterm"

# shellcheck source=/dev/null
source "${WEZTERM_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${WEZTERM_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${WEZTERM_PATH}/pkg/main.zsh"
