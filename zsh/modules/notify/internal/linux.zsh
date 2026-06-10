# shellcheck shell=bash
# Linux-specific notify internals

# Show a Linux notification via notify-send
function notify::internal::popup {
    # $1 subtitle of the notification (the command that was executed)
    # $2 the message for the notification
    # $3 the icon for the notification popup
    notify-send --urgency=low -i "${ZSH_NOTIFY_ASSETS_PATH}/${3}" \
        "Long running command: ${1}" "${2}"
}
