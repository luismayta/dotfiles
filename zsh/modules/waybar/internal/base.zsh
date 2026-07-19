# shellcheck shell=bash

function waybar::internal::install {
    message_info "Installing ${WAYBAR_PACKAGE_NAME}"
    core::install waybar
    message_success "Installed ${WAYBAR_PACKAGE_NAME}"
}

function waybar::internal::config::sync {
    rsync -avzh --progress "${ZSH_WAYBAR_DATA_PATH}/" "${WAYBAR_CONFIG_PATH}/"
}
