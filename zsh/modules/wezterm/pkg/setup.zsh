# shellcheck shell=bash

function wezterm::setup {
    message_info "Setting up ${WEZTERM_PACKAGE_NAME}..."

    if ! core::exists wezterm; then
        wezterm::install
    else
        message_info "${WEZTERM_PACKAGE_NAME} is already installed."
    fi

    wezterm::sync
    message_success "${WEZTERM_PACKAGE_NAME} setup complete."
}
