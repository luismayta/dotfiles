# shellcheck shell=bash
# Linux-specific notify internals

# Show a Linux notification via noti (primary) or notify-send (fallback)
function notify::internal::popup {
    # $1 subtitle of the notification (the command that was executed)
    # $2 the message for the notification
    # $3 the icon for the notification popup

    if core::exists noti; then
        notify::noti::internal::send "${1}" "${2}"
    elif core::exists notify-send; then
        notify::notify-send::internal::send "${1}" "${2}" "${3}"
    fi
}
