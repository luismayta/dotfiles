# Antidote - public API

antidote::init() {
  if [[ ! -f "${ANTIDOTE_PATH}/antidote.zsh" ]]; then
    message_error "antidote not installed at ${ANTIDOTE_PATH}"
    return 1
  fi

  source "${ANTIDOTE_PATH}/antidote.zsh"

  touch "${ANTIDOTE_CUSTOM_PLUGINS_FILE}"
  cat "${ANTIDOTE_PLUGINS_FILE}" "${ANTIDOTE_CUSTOM_PLUGINS_FILE}" > "${ANTIDOTE_BUNDLE_FILE}"
  antidote load "${ANTIDOTE_BUNDLE_FILE}"
}
