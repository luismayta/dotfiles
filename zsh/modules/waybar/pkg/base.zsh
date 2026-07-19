# shellcheck shell=bash

function waybar::install {
    waybar::internal::install
}

function waybar::sync {
    waybar::internal::config::sync
}

function waybar::post_install {
    message_info "Post Install ${WAYBAR_PACKAGE_NAME}"
    waybar::sync
    message_success "Success Install ${WAYBAR_PACKAGE_NAME}"
}
