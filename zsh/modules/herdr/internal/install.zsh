# shellcheck shell=bash

# ──────────────────────────────────────────────
# Install helpers
# ──────────────────────────────────────────────

function herdr::internal::install {
    if core::exists herdr; then
        message_info "${ZSH_HERDR_PACKAGE_NAME} is already installed."
        return 0
    fi

    core::ensure curl

    message_info "Installing ${ZSH_HERDR_PACKAGE_NAME}..."
    if curl -fsSL "${ZSH_HERDR_INSTALL_URL}" | sh; then
        if core::exists herdr; then
            message_success "${ZSH_HERDR_PACKAGE_NAME} installed successfully"
            return 0
        fi
        message_warning "${ZSH_HERDR_PACKAGE_NAME} install script ran but binary not found in PATH"
    fi

    message_error "Failed to install ${ZSH_HERDR_PACKAGE_NAME}"
    return 1
}

function herdr::internal::config::sync {
    local src="${ZSH_HERDR_DATA_PATH}"
    local dst="${ZSH_HERDR_CONFIG_PATH}"

    if [[ ! -d "$src" ]] || [[ -z "$(ls -A "$src" 2>/dev/null)" ]]; then
        message_info "No ${ZSH_HERDR_PACKAGE_NAME} config found in data path"
        return 0
    fi

    mkdir -p "$dst"
    message_info "Syncing ${ZSH_HERDR_PACKAGE_NAME} config..."

    if rsync -avzh "$src/" "$dst/"; then
        message_success "${ZSH_HERDR_PACKAGE_NAME} config synced successfully"
    else
        message_error "Failed to sync ${ZSH_HERDR_PACKAGE_NAME} config"
        return 1
    fi
}

# ──────────────────────────────────────────────
# Plugin helpers
# ──────────────────────────────────────────────

function herdr::internal::plugin::install {
  local plugin="$1"

  if [[ -z "$plugin" ]]; then
    message_error "Usage: herdr::internal::plugin::install <owner/repo>"
    return 1
  fi

  if ! core::exists herdr; then
    message_error "herdr binary not found"
    return 1
  fi

  if herdr plugin install "$plugin" --yes; then
    message_success "Plugin '$plugin' installed"
  else
    message_error "Failed to install plugin '$plugin'"
  fi
}

function herdr::internal::plugin::install::all {
  if [[ "$ZSH_HERDR_PLUGIN_ENABLED" != true ]]; then
    message_info "Plugin management is disabled (ZSH_HERDR_PLUGIN_ENABLED != true)"
    return 0
  fi

  if [[ ${#ZSH_HERDR_INSTALL_PLUGINS[@]} -eq 0 ]]; then
    message_info "No plugins defined in ZSH_HERDR_INSTALL_PLUGINS"
    return 0
  fi

  for plugin in "${ZSH_HERDR_INSTALL_PLUGINS[@]}"; do
    if herdr plugin list 2>/dev/null | grep -qFx "$plugin"; then
      message_info "Plugin '$plugin' already installed, skipping"
    else
      herdr::internal::plugin::install "$plugin"
    fi
  done
}

function herdr::internal::plugin::list {
  if ! core::exists herdr; then
    message_error "herdr binary not found"
    return 1
  fi

  local output
  output="$(herdr plugin list 2>/dev/null)"

  if [[ -z "$output" ]]; then
    message_info "No plugins installed"
    return 0
  fi

  printf '%s\n' "$output"
}

function herdr::internal::plugin::update {
  local plugin="$1"

  if [[ -z "$plugin" ]]; then
    message_error "Usage: herdr::internal::plugin::update <owner/repo>"
    return 1
  fi

  if ! core::exists herdr; then
    message_error "herdr binary not found"
    return 1
  fi

  if herdr plugin install "$plugin" --yes; then
    message_success "Plugin '$plugin' updated"
  else
    message_error "Failed to update plugin '$plugin'"
  fi
}

function herdr::internal::plugin::update::all {
  if [[ ${#ZSH_HERDR_INSTALL_PLUGINS[@]} -eq 0 ]]; then
    message_info "No plugins defined in ZSH_HERDR_INSTALL_PLUGINS"
    return 0
  fi

  for plugin in "${ZSH_HERDR_INSTALL_PLUGINS[@]}"; do
    herdr::internal::plugin::update "$plugin"
  done
}

function herdr::internal::plugin::uninstall {
  local plugin="$1"

  if [[ -z "$plugin" ]]; then
    message_error "Usage: herdr::internal::plugin::uninstall <owner/repo>"
    return 1
  fi

  if ! core::exists herdr; then
    message_error "herdr binary not found"
    return 1
  fi

  if ! herdr plugin list 2>/dev/null | grep -qFx "$plugin"; then
    message_warning "Plugin '$plugin' is not installed"
    return 0
  fi

  if herdr plugin uninstall "$plugin"; then
    message_success "Plugin '$plugin' uninstalled"
  else
    message_error "Failed to uninstall plugin '$plugin'"
  fi
}
