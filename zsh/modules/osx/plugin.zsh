# shellcheck shell=bash
# osx module — macOS system settings, host-scoped defaults and privileged-op reporting

[[ -n "${__ZSH_OSX_LOADED:-}" ]] && return
__ZSH_OSX_LOADED=1

ZSH_OSX_PATH="${0:A:h}"

message_info "Loading module: osx"

# shellcheck source=/dev/null
source "${ZSH_OSX_PATH}/config/main.zsh"

# `return 0`, not a bare `return`. The bare form propagates the status of the
# failed `$ZSH_OSX_ENABLED` test — 1 when the value `false` resolves to
# /usr/bin/false, 127 when no such command exists — so sourcing this file on a
# non-macOS host made the *shell itself* exit non-zero, even though the module
# loaded and printed its message correctly. Module loading is a successful
# operation, so it must return 0 unconditionally.
$ZSH_OSX_ENABLED || return 0

# shellcheck source=/dev/null
source "${ZSH_OSX_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_OSX_PATH}/pkg/main.zsh"
