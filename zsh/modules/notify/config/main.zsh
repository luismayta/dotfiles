# shellcheck shell=bash
# Notify config OS dispatch + provider adapter dispatch

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_NOTIFY_PATH}/config/osx.zsh"
    ;;
linux*)
    # shellcheck source=/dev/null
    source "${ZSH_NOTIFY_PATH}/config/linux.zsh"
    ;;
esac

# Provider-level dispatch — sources the adapter config for the active provider
case "${ZSH_NOTIFY_PROVIDER}" in
noti)
    # shellcheck source=/dev/null
    source "${ZSH_NOTIFY_PATH}/config/adapter/noti.zsh"
    ;;
notify-send)
    # shellcheck source=/dev/null
    source "${ZSH_NOTIFY_PATH}/config/adapter/notify-send.zsh"
    ;;
esac