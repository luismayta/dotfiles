# shellcheck shell=bash
# Internal notify helper functions (ported from zsh-notify)

# Store the last command and its start time (called from preexec hook)
function notify::internal::command::store {
    # shellcheck disable=SC2296,SC2299,SC1072,SC1073,SC1035,SC1009
    if [[ "${1}" -regex-match "${_ZSH_NOTIFY_RE_SKIP_COMMANDS}" ]]; then
        return
    fi

    _zsh_notify_last_command="${1}"
    _zsh_notify_start_time=$EPOCHSECONDS
}

# Check if a long-running command completed and trigger notification
function notify::internal::command::completed {
    # we must catch $? as soon as possible.
    local last_status=$?

    local now
    local timediff
    now=$EPOCHSECONDS

    if [ -z "${_zsh_notify_start_time}" ]; then
        return
    fi

    timediff="$(( now - _zsh_notify_start_time ))"

    if (( timediff > _ZSH_NOTIFY_TIME_THRESHOLD )); then
        if [[ "${last_status}" = 0 ]]; then
            notify::internal::success "${_zsh_notify_last_command}" "${timediff}"
        else
            notify::internal::error "${_zsh_notify_last_command}" "${timediff}" "${last_status}"
        fi
    fi

    unset _zsh_notify_last_command
    unset _zsh_notify_start_time
}

# Play notification sound via mpg123.
# Prompt-safe wrapper (design D1-D4): never blocks the prompt, never touches
# the terminal, and ALWAYS returns 0 so it can never truncate the
# precmd_functions hook chain.
function notify::internal::play {
    # D1 presence check: without mpg123 on PATH there is nothing to run —
    # return 0 without spawning anything.
    if ! command -v mpg123 >/dev/null 2>&1; then
        return 0
    fi

    # D4 singleton guard: a live mpg123 for this user means a playback is
    # already in flight — skip so repeated prompts never accumulate players.
    if command -v pgrep >/dev/null 2>&1 && pgrep -u "$UID" -x mpg123 >/dev/null 2>&1; then
        return 0
    fi

    # D3 hard bound, resolved at call time (coreutils `timeout` on Linux,
    # `gtimeout` on macOS). Without either, the spawn below still detaches
    # and stays terminal-safe (the freeze class is gone) but has no SIGKILL
    # backstop — degrade with a one-time warning (design D3/D8 risk note).
    local -a notify_timeout
    if command -v timeout >/dev/null 2>&1; then
        notify_timeout=(timeout -k 2 8)
    elif command -v gtimeout >/dev/null 2>&1; then
        notify_timeout=(gtimeout -k 2 8)
    else
        notify_timeout=()
        if [[ -z "${_zsh_notify_timeout_warned:-}" ]]; then
            typeset -g _zsh_notify_timeout_warned=1
            message_warning "notify: timeout/gtimeout not found: sound playback is detached but unbounded (install coreutils for the 8 s + SIGKILL bound)"
        fi
    fi

    # D2 (mandatory alongside backgrounding): --no-control stops mpg123 from
    # taking terminal control and stdin </dev/null keeps it off the tty —
    # otherwise a backgrounded player hits tcsetattr() from a background
    # process group, the tty raises SIGTTOU, and the job is permanently
    # `suspended (tty output)`. &! backgrounds and disowns: the shell never
    # waits for playback.
    command "${notify_timeout[@]}" mpg123 --no-control -q "${1}" </dev/null >/dev/null 2>&1 &!
    return 0
}

# Show success notification
function notify::internal::success {
    notify::internal::popup "${1}" "The command succeeded after ${2} seconds" success.jpg
    notify::internal::play "${ZSH_NOTIFY_ASSETS_SOUND_PATH}/${ZSH_NOTIFY_SOUND_THEME}/success.mp3"
}

# Show error notification
function notify::internal::error {
    notify::internal::popup "${1}" "The command failed after ${2} seconds with code: ${3}" error.png
    notify::internal::play "${ZSH_NOTIFY_ASSETS_SOUND_PATH}/${ZSH_NOTIFY_SOUND_THEME}/error.mp3"
}

# Default popup stub (overridden by OS-specific implementation)
function notify::internal::popup {
    return
}

function notify::internal::sync {
    local src="${ZSH_NOTIFY_DATA_SHARE_PATH}"
    local dst="${ZSH_NOTIFY_CONFIG_PATH}"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        rsync -a "$src/" "$dst/"
        message_success "notify config synced"
    else
        message_warning "no notify config source at ${src}"
    fi
}
