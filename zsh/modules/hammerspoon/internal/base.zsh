# shellcheck shell=bash

function hammerspoon::internal::install {
    if core::exists hammerspoon; then
        return 0
    fi
    message_info "Installing ${HAMMERSPOON_PACK_NAME}..."
    core::install hammerspoon
    message_success "${HAMMERSPOON_PACK_NAME} installed successfully."
}

function hammerspoon::internal::config::sync {
    message_info "Syncing hammerspoon configuration"
    if ! core::exists rsync; then core::install rsync; fi
    rsync -avh --no-perms "${ZSH_HAMMERSPOON_DATA_PATH}/" "${HAMMERSPOON_CONFIG_PATH}/"
    message_success "Synced hammerspoon configuration"
}
