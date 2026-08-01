# shellcheck shell=bash

# Antidote - internal implementation

antidote::internal::antidote::install() {
  if [[ -f "${ANTIDOTE_PATH}/antidote.zsh" ]]; then
    message_info "antidote already installed, skipping"
    return 0
  fi

  if ! command -v git >/dev/null 2>&1; then
    message_error "git is required to install antidote"
    return 1
  fi

  message_info "Installing antidote plugin manager"
  if ! git clone --depth 1 https://github.com/mattmc3/antidote.git "${ANTIDOTE_PATH}" 2>/dev/null; then
    message_error "failed to clone antidote to ${ANTIDOTE_PATH}"
    return 1
  fi

  message_info "antidote installed at ${ANTIDOTE_PATH}"
}
