# shellcheck shell=bash
SSH_PATH="${0:A:h}"
message_info "Loading module: ssh"

# Rsync guard — ensure rsync is available for data directory operations
if ! core::exists rsync; then
    core::install rsync
fi

if [[ -z "${__ZSH_SSH_LOADED}" ]]; then
  __ZSH_SSH_LOADED="true"
  # shellcheck source=/dev/null
  source "${SSH_PATH}/config/main.zsh"
  # enabled guard
  $ZSH_SSH_ENABLED || return
  # shellcheck source=/dev/null
  source "${SSH_PATH}/internal/main.zsh"
  # shellcheck source=/dev/null
  source "${SSH_PATH}/pkg/main.zsh"
  # shellcheck source=/dev/null
  source "${SSH_PATH}/keybindings.zsh"
fi
