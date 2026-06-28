#
# shellcheck shell=bash
# python ZSH module
#
# Port of luismayta/zsh-pyenv into the modules/ convention.
# Provides python (Python version manager) installation, PATH management,
# and Python version setup with OS-specific dispatch (macOS/Linux).
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_PYTHON_LOADED:-}" ]] && return
__ZSH_PYTHON_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_PYTHON_PATH="$(dirname "${0}")"

message_info "Loading module: python"

# shellcheck source=/dev/null
source "${ZSH_PYTHON_PATH}/config/main.zsh"
$ZSH_PYTHON_ENABLED || return

# shellcheck source=/dev/null
source "${ZSH_PYTHON_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_PYTHON_PATH}/pkg/main.zsh"
