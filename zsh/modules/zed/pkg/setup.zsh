# shellcheck shell=bash

function zed::setup {
    message_info "Setting up ${ZED_PACKAGE_NAME} Editor..."
    if ! core::exists zed; then
        zed::install
    else
        message_info "${ZED_PACKAGE_NAME} Editor is already installed."
    fi
    zed::sync
    message_success "${ZED_PACKAGE_NAME} Editor setup complete."
}
