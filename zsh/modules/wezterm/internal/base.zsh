# shellcheck shell=bash

function wezterm::internal::install {
    if core::exists wezterm; then
        return 0
    fi
    message_info "Installing ${WEZTERM_PACKAGE_NAME}..."
    core::install wezterm
    message_success "${WEZTERM_PACKAGE_NAME} installed successfully."
}

function wezterm::internal::config::sync {
    message_info "Syncing wezterm configuration"
    if ! core::exists rsync; then core::install rsync; fi
    rsync -avh --no-perms "${ZSH_WEZTERM_DATA_PATH}/" "${WEZTERM_CONFIG_PATH}/"
    message_success "Synced wezterm configuration"
}
