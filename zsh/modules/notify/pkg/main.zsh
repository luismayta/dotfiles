# shellcheck shell=bash
# Notify public API OS dispatch

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/pkg/base.zsh"

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/pkg/noti.zsh"

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/pkg/notify-send.zsh"

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_NOTIFY_PATH}/pkg/osx.zsh"
    ;;
linux*)
    # shellcheck source=/dev/null
    source "${ZSH_NOTIFY_PATH}/pkg/linux.zsh"
    ;;
esac
