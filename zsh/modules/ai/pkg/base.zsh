# shellcheck shell=bash

function ai::install {
  ai::internal::packages::install
}

function ai::post_install {
  message_info "Post Install ${ZSH_AI_PACKAGE_NAME}"
  message_success "Success Install ${ZSH_AI_PACKAGE_NAME}"
}

function ai::upgrade {
  message_warning "method not implement"
}

function ai::packages::install {
  ai::internal::packages::install
}

function ai::sync {
  ai::opencode::sync
  ai::fabric::patterns::sync
  ai::hunk::config::sync
  ai::pi::config::sync
}
