# shellcheck shell=bash
# MPD internal — install mpd and mpc

mpd::internal::install() {
  if ! core::exists mpd; then
    message_info "Installing ${MPD_PACKAGE_NAME}"
    core::install "${MPD_PACKAGE_NAME}"
    message_success "Installed ${MPD_PACKAGE_NAME}"
  fi
  if ! core::exists mpc; then
    message_info "Installing ${MPD_MPC_PACKAGE_NAME}"
    core::install "${MPD_MPC_PACKAGE_NAME}"
    message_success "Installed ${MPD_MPC_PACKAGE_NAME}"
  fi
}
