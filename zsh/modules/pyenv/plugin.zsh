#
# shellcheck shell=bash
# pyenv ZSH module
#
# Port of luismayta/zsh-pyenv into the modules/ convention.
# Provides pyenv (Python version manager) installation, PATH management,
# and Python version setup with OS-specific dispatch (macOS/Linux).
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_PYENV_LOADED:-}" ]] && return
__ZSH_PYENV_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_PYENV_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${ZSH_PYENV_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_PYENV_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_PYENV_PATH}/pkg/main.zsh"
