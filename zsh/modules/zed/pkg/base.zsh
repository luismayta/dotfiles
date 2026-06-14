# shellcheck shell=bash

function zed::install {
    zed::internal::install
}

function zed::sync {
    zed::internal::config::sync
}

function zed::post_install {
    message_info "Post Install ${ZED_PACKAGE_NAME}"
    zed::sync
    message_success "Success Install ${ZED_PACKAGE_NAME}"
}
