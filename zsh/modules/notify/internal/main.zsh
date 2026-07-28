# shellcheck shell=bash
# Notify internal OS dispatch
#
# Sources all internal function files, then runs runtime initialization:
#   - mpg123 availability
#   - noti auto-install + render
#   - preexec/precmd hook registration

zmodload zsh/regex

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/internal/base.zsh"

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/internal/noti.zsh"

# shellcheck source=/dev/null
source "${ZSH_NOTIFY_PATH}/internal/notify-send.zsh"

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

# === Runtime initialization ===

# Ensure mpg123 is available for sound playback
core::ensure mpg123

# Ensure gomplate for config template rendering (only if noti is available)
core::ensure gomplate

if ! core::exists noti; then notify::noti::internal::install; fi

# Register hooks for automatic notifications
autoload -Uz add-zsh-hook
add-zsh-hook preexec notify::command::store
add-zsh-hook precmd notify::command::completed