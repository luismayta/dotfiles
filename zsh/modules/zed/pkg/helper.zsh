# shellcheck shell=bash

function zed::setup {
    message_info "Setting up Zed Editor..."
    if ! core::exists zed; then
        zed::install
    else
        message_info "Zed Editor is already installed."
    fi
    zed::sync
    message_success "Zed Editor setup complete."
}
