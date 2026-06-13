#
# shellcheck shell=bash
# Docker ZSH module
#
# Port of hadenlabs/zsh-docker into the modules/ convention.
# Provides container runtime management, docker CLI wrappers,
# aliases, and cleanup utilities.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_DOCKER_LOADED:-}" ]] && return
__ZSH_DOCKER_LOADED=1

# Module root path — used by all sourced sub-files
DOCKER_PATH="$(dirname "${0}")"
message_info "Loading module: docker"

# shellcheck source=/dev/null
source "${DOCKER_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${DOCKER_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${DOCKER_PATH}/pkg/main.zsh"
