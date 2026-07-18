# shellcheck shell=bash

keybase::install() {
    keybase::internal::install
}

keybase::sync() {
    keybase::internal::config::sync
}

keybase::post_install() {
    message_info "Post Install ${ZSH_KEYBASE_PACKAGE_NAME}"
    keybase::sync
    message_success "Post Install ${ZSH_KEYBASE_PACKAGE_NAME}"
}
