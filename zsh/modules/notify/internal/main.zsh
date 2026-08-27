# shellcheck shell=bash
# Notify internal OS dispatch + provider adapter dispatch
#
# Sources all internal function files, then runs runtime initialization:
#   - mpg123 availability
#   - gomplate if needed
#   - preexec/precmd hook registration

zmodload zsh/regex

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

# Provider-level dispatch — sources the active adapter internal
case "${ZSH_NOTIFY_PROVIDER}" in
noti)
    # shellcheck source=/dev/null
    source "${ZSH_NOTIFY_PATH}/internal/adapter/noti.zsh"
    ;;
notify-send)
    # shellcheck source=/dev/null
    source "${ZSH_NOTIFY_PATH}/internal/adapter/notify-send.zsh"
    ;;
auto)
    # Auto-detect: load only the first available adapter
    # shellcheck source=/dev/null
    if core::exists noti; then
        source "${ZSH_NOTIFY_PATH}/internal/adapter/noti.zsh"
    else
        # shellcheck source=/dev/null
        source "${ZSH_NOTIFY_PATH}/internal/adapter/notify-send.zsh"
    fi
    ;;
esac

# === Runtime initialization ===

# Ensure mpg123 is available for sound playback
core::ensure mpg123

# Ensure gomplate is available for template rendering
if [[ "${ZSH_NOTIFY_PROVIDER}" == "noti" ]]; then
    core::ensure gomplate
fi

# Register hooks for automatic notifications
autoload -Uz add-zsh-hook
add-zsh-hook preexec notify::command::store
add-zsh-hook precmd notify::command::completed
