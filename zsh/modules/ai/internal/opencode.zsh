# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::opencode::load {
    [ -e "${AI_OPENCODE_BIN_PATH}" ] && export PATH="${AI_OPENCODE_BIN_PATH}:${PATH}"
}

function ai::internal::opencode::sync_quiet {
    mkdir -p "${AI_OPENCODE_CONFIG_PATH}" "${AI_OPENCODE_RUNTIME_CONFIG_PATH}"
    rsync -a "${AI_OPENCODE_CONFIG_SOURCE_PATH}/" "${AI_OPENCODE_CONFIG_PATH}/" \
        && rsync -a --exclude "node_modules" "${AI_OPENCODE_RUNTIME_SOURCE_PATH}/" "${AI_OPENCODE_RUNTIME_CONFIG_PATH}/"
}

# === Tool Install ===

function ai::internal::opencode::install {
    if core::exists opencode; then
        return 0
    fi

    message_info "Installing opencode..."
    if curl -fsSL "${AI_INSTALL_URL_OPENCODE}" | bash; then
        message_success "opencode installed successfully"
    else
        message_error "Failed to install opencode"
        return 1
    fi
}

function ai::internal::opencode::sync {
    if ! core::exists rsync; then
        message_error "rsync is not installed"
        return 1
    fi

    message_info "Syncing opencode config from ${AI_OPENCODE_CONFIG_SOURCE_PATH} to ${AI_OPENCODE_CONFIG_PATH}..."

    if ai::internal::opencode::sync_quiet; then
        message_success "opencode config synced successfully"
    else
        message_error "Failed to sync opencode config"
        return 1
    fi
}
