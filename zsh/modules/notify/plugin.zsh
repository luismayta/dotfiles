# shellcheck shell=bash
# Notify plugin loader
#
# Provides notification services for long-running commands.
# Supports noti (Telegram) and notify-send/terminal-notifier (desktop).
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh

# Idempotency guard
[[ -n "${__ZSH_NOTIFY_LOADED:-}" ]] && return
__ZSH_NOTIFY_LOADED=1

# shellcheck disable=SC2277,SC2296,SC2298,SC2299
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
# shellcheck disable=SC2277,SC2296,SC2298,SC2299
0="${${(M)0:#/*}:-$PWD/$0}"

export ZSH_NOTIFY_PATH="${0:h}"
message_info "Loading module: notify"

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/config/main.zsh"
$ZSH_NOTIFY_ENABLED || return

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/pkg/main.zsh"
