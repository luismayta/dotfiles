#
# shellcheck shell=bash
# Docker ZSH module
#

# Idempotency guard
[[ -n "${__ZSH_DOCKER_LOADED:-}" ]] && return
__ZSH_DOCKER_LOADED=1

# Module root path — used by all sourced sub-files
DOCKER_PATH="$(dirname "${0}")"
message_info "Loading module: ${DOCKER_PACKAGE_NAME}"

# shellcheck source=/dev/null
source "${DOCKER_PATH}/config/main.zsh"
$ZSH_DOCKER_ENABLED || return

# shellcheck source=/dev/null
source "${DOCKER_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${DOCKER_PATH}/pkg/main.zsh"
