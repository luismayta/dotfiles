# shellcheck shell=bash
# macOS MPD internals — brew services management

mpd::internal::load() {
  if command -v brew &>/dev/null; then
    if ! brew services list | grep -q "^${MPD_SERVICE_NAME}.*started"; then
      message_info "Starting MPD via brew services"
      brew services start "${MPD_PACKAGE_NAME}"
      message_success "MPD started via brew services"
    fi
  fi
}

mpd::internal::stop() {
  if command -v brew &>/dev/null; then
    brew services stop "${MPD_PACKAGE_NAME}"
    message_success "MPD stopped via brew services"
  fi
}

mpd::internal::status() {
  if command -v brew &>/dev/null; then
    brew services list | grep "^${MPD_SERVICE_NAME}"
  fi
}
