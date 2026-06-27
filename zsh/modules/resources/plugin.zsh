# shellcheck shell=bash
RESOURCES_PATH="${0:A:h}"
message_info "Loading module: resources"

if [[ -z "${__ZSH_RESOURCES_LOADED}" ]]; then
  __ZSH_RESOURCES_LOADED="true"
  # shellcheck source=/dev/null
  source "${RESOURCES_PATH}/config/main.zsh"
  # enabled guard
  $ZSH_RESOURCES_ENABLED || return
  # shellcheck source=/dev/null
  source "${RESOURCES_PATH}/internal/main.zsh"
  # shellcheck source=/dev/null
  source "${RESOURCES_PATH}/pkg/main.zsh"
fi
