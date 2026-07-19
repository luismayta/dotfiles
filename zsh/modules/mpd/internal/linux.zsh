# shellcheck shell=bash
# Linux MPD internals — systemd service management

mpd::internal::load() {
  if systemctl --user is-enabled --quiet "${MPD_SERVICE_NAME}" 2>/dev/null; then
    if ! systemctl --user is-active --quiet "${MPD_SERVICE_NAME}" 2>/dev/null; then
      message_info "Starting MPD service"
      systemctl --user start "${MPD_SERVICE_NAME}"
      message_success "MPD service started"
    fi
  else
    message_info "Enabling MPD service"
    systemctl --user enable --now "${MPD_SERVICE_NAME}"
    message_success "MPD service enabled and started"
  fi
}

mpd::internal::stop() {
  if systemctl --user is-active --quiet "${MPD_SERVICE_NAME}" 2>/dev/null; then
    systemctl --user stop "${MPD_SERVICE_NAME}"
    message_success "MPD service stopped"
  fi
}

mpd::internal::status() {
  systemctl --user status "${MPD_SERVICE_NAME}" --no-pager
}
