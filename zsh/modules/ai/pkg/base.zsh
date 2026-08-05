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

function ai::setup {
  local failures=0

  ai::codegraph::setup || (( failures++ ))
  ai::openspec::setup || (( failures++ ))
  ai::graphify::setup || (( failures++ ))

  if (( failures > 0 )); then
    message_error "ai setup completed with ${failures} failure(s)"
    return 1
  fi

  message_success "ai setup complete"
}
