# shellcheck shell=bash
# shellcheck disable=SC1009,SC1035,SC1072,SC1073
# Notify internal OS dispatch + provider adapter dispatch
#
# Sources all internal function files, then runs runtime initialization:
#   - mpg123 / gomplate detection (warn when missing — NEVER install on
#     shell startup, RD-256 / design D5)
#   - bounded adapter dispatch helper (design D8)
#   - preexec/precmd hook registration

zmodload zsh/regex
# EPOCHSECONDS for the prompt hooks in internal/base.zsh (design D7,
# migration step 1): zshrc only loads zsh/datetime inside the darwin
# compinit branch, so the notify load path must load it itself.
zmodload zsh/datetime

# === Bounded dispatch (design D8) ===
# Run a notification provider under a hard bound — `timeout -k 2 5`:
# SIGTERM after 5 s, then SIGKILL after a 2 s grace — so a hung provider
# (stalled network or D-Bus call) degrades to "no popup this time" instead
# of "no prompt". timeout/gtimeout are resolved at CALL time because macOS
# ships neither by default (design Risks): when no bound tool is on PATH the
# command still runs — disowned in the background, with its flags and
# redirections unchanged — after a one-time warning that it is unbounded.
function notify::internal::bounded {
    local _bound=""
    if command -v timeout >/dev/null 2>&1; then
        _bound="timeout"
    elif command -v gtimeout >/dev/null 2>&1; then
        _bound="gtimeout"
    fi

    if [[ -z "${_bound}" ]]; then
        if (( ! ${+_ZSH_NOTIFY_TIMEOUT_WARNED} )); then
            typeset -g _ZSH_NOTIFY_TIMEOUT_WARNED=1
            message_warning "notify: neither timeout nor gtimeout on PATH: dispatching notifications unbounded; install coreutils for the 5 s bound"
        fi
        "$@" &!
        return 0
    fi

    command "${_bound}" -k 2 5 "$@"
}

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
# Detect missing tools and warn — shell startup must never invoke a package
# manager (RD-256 / design D5). Installing stays an explicit user action
# through core::install.

# mpg123 is required for sound playback
if ! core::exists mpg123; then
    message_warning "notify: mpg123 missing: sound playback disabled; install it explicitly: core::install mpg123"
fi

# gomplate renders the noti config template (noti provider only)
if [[ "${ZSH_NOTIFY_PROVIDER}" == "noti" ]]; then
    if ! core::exists gomplate; then
        message_warning "notify: gomplate missing: noti config rendering disabled; install it explicitly: core::install gomplate"
    fi
fi

# Register hooks for automatic notifications
autoload -Uz add-zsh-hook
add-zsh-hook preexec notify::command::store
add-zsh-hook precmd notify::command::completed
