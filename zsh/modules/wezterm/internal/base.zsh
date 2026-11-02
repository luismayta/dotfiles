# shellcheck shell=bash

function wezterm::internal::config::sync {
    message_info "Syncing wezterm configuration"
    if ! core::exists rsync; then core::install rsync; fi
    rsync -avh --no-perms "${ZSH_WEZTERM_DATA_PATH}/" "${WEZTERM_CONFIG_PATH}/"
    message_success "Synced wezterm configuration"
}