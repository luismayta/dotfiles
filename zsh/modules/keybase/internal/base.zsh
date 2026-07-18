# shellcheck shell=bash

function keybase::internal::install {
    if core::exists keybase; then
        return 0
    fi
    message_info "Installing ${ZSH_KEYBASE_PACKAGE_NAME}..."
    core::install keybase
    message_success "${ZSH_KEYBASE_PACKAGE_NAME} installed successfully."
}

function keybase::internal::config::sync {
    message_info "Syncing keybase configuration"
    if ! core::exists rsync; then core::install rsync; fi
    rsync -avh --no-perms "${ZSH_KEYBASE_DATA_PATH}/" "${ZSH_KEYBASE_CONFIG_PATH}/"
    message_success "Synced keybase configuration"
}
