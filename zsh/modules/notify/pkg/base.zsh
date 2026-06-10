# shellcheck shell=bash
# Notify public API functions (ported from zsh-notify)

function notify::dependencies {
    message_info "Installing dependencies for ${NOTIFY_PACKAGE_NAME}"
    message_success "Installed dependencies for ${NOTIFY_PACKAGE_NAME}"
}

function notify::success {
    notify::internal::success "${1}" "${2}"
}

function notify::error {
    notify::internal::error "${1}" "${2}" "${3}"
}

function notify::play {
    notify::internal::play "${1}"
}

function notify::popup {
    notify::internal::popup
}

function notify::command::completed {
    notify::internal::command::completed
}

function notify::command::store {
    notify::internal::command::store "${@}"
}
