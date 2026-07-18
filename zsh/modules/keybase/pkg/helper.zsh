# shellcheck shell=bash

keybase::setup() {
    message_info "Setting up ${ZSH_KEYBASE_PACKAGE_NAME}..."
    if ! core::exists keybase; then
        keybase::install
    else
        message_info "${ZSH_KEYBASE_PACKAGE_NAME} is already installed."
    fi
    keybase::sync
    message_success "${ZSH_KEYBASE_PACKAGE_NAME} setup complete."
}
