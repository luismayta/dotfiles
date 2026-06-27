# shellcheck shell=bash
# Public API: Devbox module

devbox::install() {
  devbox::internal::devbox::install
}

devbox::sync() {
  if [ -d "${DEVBOX_DATA_PATH}" ]; then
    rsync -avh "${DEVBOX_DATA_PATH}/" "${DEVBOX_GLOBAL_CONFIG_PATH}/"
    core::internal::message::success "Devbox config synced"
  else
    core::internal::message::warning "No devbox data found at ${DEVBOX_DATA_PATH}"
  fi
}

devbox::shell() {
  devbox shell "${@}"
}

devbox::init() {
  devbox init "${@}"
}
