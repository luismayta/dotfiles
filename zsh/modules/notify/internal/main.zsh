# shellcheck shell=bash
# Notify internal OS dispatch

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_NOTIFY_PATH}/internal/osx.zsh"
    ;;
linux*)
    # shellcheck source=/dev/null
    source "${ZSH_NOTIFY_PATH}/internal/linux.zsh"
    ;;
esac

# Ensure mpg123 is available for sound playback
if ! core::exists mpg123; then core::install mpg123; fi
