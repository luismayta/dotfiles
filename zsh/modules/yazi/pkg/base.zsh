# shellcheck shell=bash

function yazi::install {
  yazi::internal::install
}

function yazi::sync {
  yazi::internal::config::sync
}

function yazi::post_install {
  message_info "Post Install ${ZSH_YAZI_PACKAGE_NAME}"
  yazi::sync
  message_success "Success Install ${ZSH_YAZI_PACKAGE_NAME}"
}
