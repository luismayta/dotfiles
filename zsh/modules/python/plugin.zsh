#
# shellcheck shell=bash
# python ZSH module
#
# Provides Python toolchain management via uv: interpreter installation
# (`uv python install`), PATH management, and Python version setup with
# OS-specific dispatch (macOS/Linux).
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_PYTHON_LOADED:-}" ]] && return
__ZSH_PYTHON_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_PYTHON_PATH="${0:A:h}"

message_info "Loading module: python"

# shellcheck source=/dev/null
source "${ZSH_PYTHON_PATH}/config/main.zsh"
$ZSH_PYTHON_ENABLED || return

# shellcheck source=/dev/null
source "${ZSH_PYTHON_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_PYTHON_PATH}/pkg/main.zsh"
