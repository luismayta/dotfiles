# shellcheck shell=bash
# notify-send backend implementation

# === Install ===

function notify::notify-send::internal::install {
    if core::exists notify-send; then
        return 0
    fi

    message_info "Installing notify-send..."
    if core::install "${ZSH_NOTIFY_NOTIFY_SEND_PACKAGE_NAME}"; then
        message_success "notify-send installed successfully"
    else
        message_error "Failed to install notify-send"
        return 1
    fi
}

# === Send ===

function notify::notify-send::internal::send {
    if ! core::exists notify-send; then
        message_error "notify-send: not installed. Run: notify::notify-send::install"
        return 1
    fi

    # $1 subtitle (command that was executed)
    # $2 message to display
    # $3 icon filename
    notify-send --urgency=low -i "${ZSH_NOTIFY_NOTIFY_SEND_ICON_PATH}/${3}" \
        "Long running command: ${1}" "${2}"
}

# === Adapter Contract ===

function notify::adapter::send {
    notify::notify-send::internal::send "${1}" "${2}" "${3}"
}

function notify::adapter::install {
    notify::notify-send::internal::install
}

# notify-send has no config files — no-op stubs
function notify::adapter::render {
    return 0
}

function notify::adapter::sync {
    return 0
}
