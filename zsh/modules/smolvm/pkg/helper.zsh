# shellcheck shell=bash

smolvm::setup() {
  message_info "Setting up ${ZSH_SMOLVM_PACKAGE_NAME}..."

  smolvm::install

  if ! smolvm::internal::verify; then
    message_error "${ZSH_SMOLVM_PACKAGE_NAME} setup failed"
    return 1
  fi
  message_success "${ZSH_SMOLVM_PACKAGE_NAME} setup complete."
}
