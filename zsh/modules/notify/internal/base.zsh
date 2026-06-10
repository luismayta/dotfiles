# shellcheck shell=bash
# Internal notify helper functions (ported from zsh-notify)

# Store the last command and its start time (called from preexec hook)
function notify::internal::command::store {
    # shellcheck disable=SC2296,SC2299,SC1072,SC1073,SC1035
    if [ "${1}" -regex-match "${_ZSH_NOTIFY_RE_SKIP_COMMANDS}" ]; then
        return
    fi

    _zsh_notify_last_command="${1}"
    _zsh_notify_start_time=$(date +%s)
}

# Check if a long-running command completed and trigger notification
function notify::internal::command::completed {
    # we must catch $? as soon as possible.
    local last_status=$?

    local now
    local timediff
    now=$(date +%s)

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

# Play notification sound via mpg123
function notify::internal::play {
    mpg123 "${1}" > /dev/null 2>&1
}

# Show success notification
function notify::internal::success {
    notify::internal::popup "${1}" "The command succeeded after ${2} seconds" success.jpg
    notify::internal::play "${ZSH_NOTIFY_ASSETS_SOUND_PATH}/r2d2/success.mp3"
}

# Show error notification
function notify::internal::error {
    notify::internal::popup "${1}" "The command failed after ${2} seconds with code: ${3}" error.png
    notify::internal::play "${ZSH_NOTIFY_ASSETS_SOUND_PATH}/r2d2/error.mp3"
}

# Default popup stub (overridden by OS-specific implementation)
function notify::internal::popup {
    return
}
