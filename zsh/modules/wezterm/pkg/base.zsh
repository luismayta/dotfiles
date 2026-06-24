# shellcheck shell=bash

function wezterm::install {
    wezterm::internal::install
}

function wezterm::sync {
    wezterm::internal::config::sync
}

function wezterm::post_install {
    message_info "Post Install ${WEZTERM_PACKAGE_NAME}"
    wezterm::sync
    message_success "Post Install ${WEZTERM_PACKAGE_NAME} complete."
}
