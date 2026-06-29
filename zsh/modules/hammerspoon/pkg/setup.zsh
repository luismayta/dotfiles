# shellcheck shell=bash

function hammerspoon::setup {
    message_info "Setting up ${HAMMERSPOON_PACK_NAME}..."

    if ! core::exists hammerspoon; then
        hammerspoon::install
    else
        message_info "${HAMMERSPOON_PACK_NAME} is already installed."
    fi

    hammerspoon::sync
    message_success "${HAMMERSPOON_PACK_NAME} setup complete."
}

