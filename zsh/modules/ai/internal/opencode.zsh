# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::opencode::load {
    [ -e "${AI_OPENCODE_BIN_PATH}" ] && export PATH="${AI_OPENCODE_BIN_PATH}:${PATH}"
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

    mkdir -p "${AI_OPENCODE_CONFIG_PATH}"

    rsync -avzh --progress "${AI_OPENCODE_CONFIG_SOURCE_PATH}/" "${AI_OPENCODE_CONFIG_PATH}/"

}