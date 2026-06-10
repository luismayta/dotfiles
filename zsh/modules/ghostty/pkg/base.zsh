# shellcheck shell=bash

function ghostty::dependences {
    message_info "Installing dependences for ${GHOSTTY_PACKAGE_NAME}"
    if ! core::exists brew; then core::install brew; fi
    message_success "Installed dependences for ${GHOSTTY_PACKAGE_NAME}"
}

function ghostty::sync {
    ghostty::internal::conf::sync
}

function ghostty::install {
    ghostty::internal::ghostty::install
}

function ghostty::post_install {
    message_info "Post Install ${GHOSTTY_PACKAGE_NAME}"
    message_success "Success Install ${GHOSTTY_PACKAGE_NAME}"
}
