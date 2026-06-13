# shellcheck shell=bash
# ghq ZSH module
#
# Port of hadenlabs/zsh-ghq into the modules/ convention.
# Provides ghq (GitHub repository manager) integration with
# interactive repository lookup via peco/fzf.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh

# Idempotency guard
[[ -n "${__ZSH_GHQ_LOADED:-}" ]] && return
__ZSH_GHQ_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_GHQ_PATH="$(dirname "${0}")"
message_info "Loading module: ghq"

# shellcheck source=/dev/null
source "${ZSH_GHQ_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_GHQ_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_GHQ_PATH}/pkg/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_GHQ_PATH}/keybindings.zsh"
