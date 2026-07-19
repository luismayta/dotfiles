# shellcheck shell=bash

function waybar::setup {
    message_info "Setting up ${WAYBAR_PACKAGE_NAME}..."
    if ! core::exists waybar; then
        waybar::install
    else
        message_info "${WAYBAR_PACKAGE_NAME} is already installed."
    fi
    waybar::sync
    message_success "${WAYBAR_PACKAGE_NAME} setup complete."
}

function waybar::check {
    if core::exists waybar; then
        message_success "waybar: installed"
    else
        message_error "waybar: not installed"
    fi
}
