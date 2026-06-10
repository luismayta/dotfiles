# shellcheck shell=bash
# Notify config OS dispatch

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
