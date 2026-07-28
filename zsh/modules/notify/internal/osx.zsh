# shellcheck shell=bash
# macOS-specific notify internals

# Show a macOS notification via noti (primary) or terminal-notifier (fallback)
function notify::internal::popup {
    # $1 subtitle of the notification (the command that was executed)
    # $2 the message for the notification
    # $3 the icon for the notification popup

    if core::exists noti; then
        notify::noti::internal::send "${1}" "${2}"
    elif core::exists terminal-notifier; then
        terminal-notifier -title "Long running command" -subtitle "${1}" \
            -message "${2}" -activate "${_ZSH_NOTIFY_TERMINAL_BUNDLE}" \
            -appIcon "${ZSH_NOTIFY_ASSETS_PATH}/${3}"
    fi
}
