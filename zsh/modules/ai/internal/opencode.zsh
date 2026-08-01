# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::opencode::load {
    [ -e "${ZSH_AI_OPENCODE_BIN_PATH}" ] && export PATH="${ZSH_AI_OPENCODE_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::opencode::install {
    if core::exists opencode; then
        return 0
    fi

    message_info "Installing opencode..."
    if curl -fsSL "${ZSH_AI_INSTALL_URL_OPENCODE}" | bash; then
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

    message_info "Syncing opencode config from ${ZSH_AI_OPENCODE_CONFIG_SOURCE_PATH} to ${ZSH_AI_OPENCODE_CONFIG_PATH}..."

    mkdir -p "${ZSH_AI_OPENCODE_CONFIG_PATH}"

    rsync -avzh --progress "${ZSH_AI_OPENCODE_CONFIG_SOURCE_PATH}/" "${ZSH_AI_OPENCODE_CONFIG_PATH}/"

}