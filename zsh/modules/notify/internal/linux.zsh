# shellcheck shell=bash
# Linux-specific notify internals

# Show a Linux notification via the active provider adapter
function notify::internal::popup {
    # $1 subtitle of the notification (the command that was executed)
    # $2 the message for the notification
    # $3 the icon for the notification popup

    notify::adapter::send "${1}" "${2}" "${3}"
}
