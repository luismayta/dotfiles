# shellcheck shell=bash
# mobile module — entry point
#
# Chains: config/main.zsh → internal/main.zsh → pkg/main.zsh
# Concerns: Android SDK, Flutter SDK, iOS tooling

[[ -n "${__ZSH_MOBILE_LOADED:-}" ]] && return
__ZSH_MOBILE_LOADED=1

ZSH_MOBILE_PATH="$(dirname "${0}")"
message_info "Loading module: ${MOBILE_PACKAGE_NAME}"

# shellcheck source=/dev/null
source "${ZSH_MOBILE_PATH}/config/main.zsh"
${ZSH_MOBILE_ENABLED} || return

# shellcheck source=/dev/null
source "${ZSH_MOBILE_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_MOBILE_PATH}/pkg/main.zsh"
