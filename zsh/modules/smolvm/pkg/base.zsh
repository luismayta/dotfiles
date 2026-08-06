# shellcheck shell=bash

smolvm::install() {
  smolvm::internal::install
}

smolvm::post_install() {
  message_info "Post Install ${ZSH_SMOLVM_PACKAGE_NAME}"
  if ! smolvm::internal::verify; then
    message_error "Post Install ${ZSH_SMOLVM_PACKAGE_NAME} failed"
    return 1
  fi
  message_success "Post Install ${ZSH_SMOLVM_PACKAGE_NAME}"
}
