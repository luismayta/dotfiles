# shellcheck shell=bash

function hammerspoon::internal::is_installed {
    [[ -d "/Applications/Hammerspoon.app" ]]
}

function hammerspoon::internal::install {
    if hammerspoon::internal::is_installed; then
        return 0
    fi
    message_info "Installing ${HAMMERSPOON_PACK_NAME}..."
    if core::install --cask "${HAMMERSPOON_PACK_NAME}"; then
        message_success "${HAMMERSPOON_PACK_NAME} installed successfully."
    else
        message_error "Failed to install ${HAMMERSPOON_PACK_NAME}."
        return 1
    fi
    return 0
}

function hammerspoon::internal::config::sync {
    message_info "Syncing hammerspoon configuration"
    if ! core::exists rsync; then core::install rsync; fi
    rsync -avh --no-perms "${ZSH_HAMMERSPOON_DATA_PATH}/" "${HAMMERSPOON_CONFIG_PATH}/"
    message_success "Synced hammerspoon configuration"
}
