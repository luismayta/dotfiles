# shellcheck shell=bash
# macOS-specific notify internals

# Ensure terminal-notifier is available
core::ensure terminal-notifier

# Show a macOS notification via terminal-notifier
function notify::internal::popup {
    # $1 subtitle of the notification (the command that was executed)
    # $2 the message for the notification
    # $3 the icon for the notification popup
    terminal-notifier -title "Long running command" -subtitle "${1}" \
        -message "${2}" -activate "${_ZSH_NOTIFY_TERMINAL_BUNDLE}" \
        -appIcon "${ZSH_NOTIFY_ASSETS_PATH}/${3}"
}
