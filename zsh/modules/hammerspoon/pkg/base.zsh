# shellcheck shell=bash

function hammerspoon::install {
    hammerspoon::internal::install
}

function hammerspoon::sync {
    hammerspoon::internal::config::sync
}

function hammerspoon::post_install {
    message_info "Post Install ${HAMMERSPOON_PACK_NAME}"
    hammerspoon::sync
    message_success "Post Install ${HAMMERSPOON_PACK_NAME} complete."
}
