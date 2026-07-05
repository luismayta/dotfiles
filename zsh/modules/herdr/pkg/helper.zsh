# shellcheck shell=bash

function herdr::setup {
  message_info "Setting up ${HERDR_PACKAGE_NAME}..."

  if ! core::exists herdr; then
    herdr::install || {
      message_error "${HERDR_PACKAGE_NAME} setup failed at install step"
      return 1
    }
  else
    message_info "${HERDR_PACKAGE_NAME} is already installed."
  fi

  herdr::sync

  message_success "${HERDR_PACKAGE_NAME} setup complete"
}
