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

# mpd::internal::ncmpcpp::config::sync — sync ncmpcpp config to ~/.ncmpcpp/
mpd::internal::ncmpcpp::config::sync() {
  local entry target sync_needed=0
  mkdir -p "${MPD_NCMP_CPP_CONFIG_PATH}"
  for entry in "${MPD_NCMP_CPP_DATA_PATH}"/**/*(ND); do
    target="${MPD_NCMP_CPP_CONFIG_PATH}/${entry#"${MPD_NCMP_CPP_DATA_PATH}"/}"
    if [[ ! -e "$target" || "$entry" -nt "$target" ]]; then
      sync_needed=1
      break
    fi
  done
  (( sync_needed )) || return 0
  message_info "Syncing ncmpcpp configuration"
  rsync -avzh --progress "${MPD_NCMP_CPP_DATA_PATH}/" "${MPD_NCMP_CPP_CONFIG_PATH}/"
  message_success "ncmpcpp configuration synced"
}

# mpd::internal::config::sync — sync mpd config to ~/.config/mpd/
mpd::internal::config::sync() {
  local src="${MPD_CONFIG_DATA_PATH}/mpd.conf"
  local dst="${MPD_CONFIG_PATH}/mpd.conf"
  mkdir -p "${MPD_CONFIG_PATH}" "${MPD_CONFIG_PATH}/playlists"
  [[ -e "$dst" && ! "$src" -nt "$dst" ]] && return 0
  message_info "Syncing MPD configuration"
  rsync -avzh --progress "${MPD_CONFIG_DATA_PATH}/mpd.conf" "${MPD_CONFIG_PATH}/mpd.conf"
  message_success "MPD configuration synced"
}
