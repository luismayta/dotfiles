# shellcheck shell=bash

function herdr::install {
  herdr::internal::install
}

function herdr::sync {
  herdr::internal::config::sync
}

function herdr::post_install {
  message_info "Post Install ${ZSH_HERDR_PACKAGE_NAME}"
  herdr::sync
  message_success "Success Install ${ZSH_HERDR_PACKAGE_NAME}"
}
