# shellcheck shell=bash
SSH_PATH="${0:A:h}"

if [[ -z "${__ZSH_SSH_LOADED}" ]]; then
  __ZSH_SSH_LOADED="true"
  # shellcheck source=/dev/null
  source "${SSH_PATH}/config/main.zsh"
  # shellcheck source=/dev/null
  source "${SSH_PATH}/internal/main.zsh"
  # shellcheck source=/dev/null
  source "${SSH_PATH}/pkg/main.zsh"
  zle -N ssh::connect
  bindkey '^Xs' ssh::connect
fi
