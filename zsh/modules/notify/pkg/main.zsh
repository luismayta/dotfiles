# shellcheck shell=bash
# Notify public API OS dispatch

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/pkg/base.zsh"

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
