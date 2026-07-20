# shellcheck shell=bash
# MPD internal — install mpd and mpc

mpd::internal::install() {
  if ! core::exists fmt; then
    message_info "Installing ${MPD_FMT_PACKAGE_NAME} (runtime dependency)"
    core::install "${MPD_FMT_PACKAGE_NAME}"
    message_success "Installed ${MPD_FMT_PACKAGE_NAME}"
  fi
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
  if ! core::exists ncmpcpp; then
    message_info "Installing ${MPD_NCMP_CPP_PACKAGE_NAME}"
    core::install "${MPD_NCMP_CPP_PACKAGE_NAME}"
    message_success "Installed ${MPD_NCMP_CPP_PACKAGE_NAME}"
  fi
}

# ncmpcpp::internal::config::sync — sync ncmpcpp config to home
mpd::internal::ncmpcpp::config::sync() {
  message_info "Syncing ncmpcpp configuration"
  mkdir -p "${MPD_NCMP_CPP_CONFIG_PATH}"
  rsync -avzh --progress "${MPD_NCMP_CPP_DATA_PATH}/" "${MPD_NCMP_CPP_CONFIG_PATH}/"
  message_success "ncmpcpp configuration synced"
}

# mpd::internal::config::sync — sync mpd config to ~/.config/mpd/
mpd::internal::config::sync() {
  message_info "Syncing MPD configuration"
  mkdir -p "${MPD_CONFIG_PATH}"
  mkdir -p "${MPD_CONFIG_PATH}/playlists"
  rsync -avzh --progress "${MPD_CONFIG_DATA_PATH}/mpd.conf" "${MPD_CONFIG_PATH}/mpd.conf"
  message_success "MPD configuration synced"
}
