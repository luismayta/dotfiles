# shellcheck shell=bash

function alacritty::dependences {
    message_info "Installing dependences for ${ALACRITTY_PACKAGE_NAME}"
    if ! core::exists brew; then core::install brew; fi
    message_success "Installed dependences for ${ALACRITTY_PACKAGE_NAME}"
}

function alacritty::sync {
    alacritty::internal::conf::sync
}

function alacritty::install {
    alacritty::internal::alacritty::install
}

function alacritty::post_install {
    message_info "Post Install ${ALACRITTY_PACKAGE_NAME}"
    message_success "Success Install ${ALACRITTY_PACKAGE_NAME}"
}
