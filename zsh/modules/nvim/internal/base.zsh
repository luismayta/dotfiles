# shellcheck shell=bash
#
# Internal core logic for the nvim module.
# Implements nvimrc installation, upgrade, and cache cleanup.

function nvim::internal::install {
  if [[ -d "${NVIM_CONFIG_PATH}" ]]; then
    return 0
  fi

  message_info "Installing nvimrc configuration..."
  command mkdir -p "${NVIM_CONFIG_PATH}"
  if ! core::exists git; then
    core::install git
  fi

  command git clone --depth=1 \
    "${NVIM_INSTALL_URL}" \
    "${NVIM_CONFIG_PATH}"
  message_success "Installed nvimrc configuration"
}

function nvim::internal::upgrade {
  if [[ ! -d "${NVIM_CONFIG_PATH}" ]]; then
    nvim::internal::install
    return 0
  fi

  message_info "Upgrading nvimrc configuration..."
  command git -C "${NVIM_CONFIG_PATH}" pull --ff-only origin main 2>/dev/null \
    || command git -C "${NVIM_CONFIG_PATH}" pull --ff-only origin master 2>/dev/null
  message_success "Upgraded nvimrc configuration"
}

function nvim::internal::clean {
  message_info "Cleaning nvim caches..."
  command rm -rf \
    "${HOME}/.local/share/nvim" \
    "${HOME}/.cache/nvim" \
    "${HOME}/.local/state/nvim" \
    "${NVIM_CONFIG_PATH}/plugin/packer_compiled.zsh" \
    2>/dev/null || true
  message_success "Cleaned nvim caches"
}
