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
    mkdir -p "${ZSH_HAMMERSPOON_CUSTOM_DIR}"
    if [[ ! -f "${ZSH_HAMMERSPOON_CUSTOM_DIR}/custom.lua" && -f "${ZSH_HAMMERSPOON_DATA_PATH}/custom.lua.example" ]]; then
        cp "${ZSH_HAMMERSPOON_DATA_PATH}/custom.lua.example" "${ZSH_HAMMERSPOON_CUSTOM_DIR}/custom.lua"
        message_info "Seeded custom override at ${ZSH_HAMMERSPOON_CUSTOM_DIR}/custom.lua from custom.lua.example"
    fi
    if [[ -f "${HOME}/.hammerspoon/custom.lua" ]]; then
        message_info "Legacy custom override found at ${HOME}/.hammerspoon/custom.lua — move it manually to ${ZSH_HAMMERSPOON_CUSTOM_DIR}/custom.lua"
    fi
    rsync -avh --no-perms "${ZSH_HAMMERSPOON_DATA_PATH}/" "${HAMMERSPOON_CONFIG_PATH}/"
    message_success "Synced hammerspoon configuration"
}
