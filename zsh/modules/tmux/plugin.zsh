#
# shellcheck shell=bash
# Tmux ZSH module
#
# Port of hadenlabs/zsh-tmux into the modules/ convention.
# Provides tmux installation, TPM management, tmuxinator setup,
# session management (ftm/ftmk), tmuxinator project launcher,
# config editor, and OS-specific clipboard integration.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_TMUX_LOADED:-}" ]] && return
__ZSH_TMUX_LOADED=1

# Module root path — used by all sourced sub-files
TMUX_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${TMUX_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${TMUX_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${TMUX_PATH}/pkg/main.zsh"

# Auto-install guards (must be after pkg/main.zsh so tmux::post_install exists)
if ! core::exists rsync; then core::install rsync; fi
if ! core::exists fzf; then core::install fzf; fi
if ! core::exists tmux; then tmux::internal::tmux::install; fi
[ -e "${TMUX_TPM_PATH}" ] || tmux::internal::tpm::install
