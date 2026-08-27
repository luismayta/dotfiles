# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::jcode::load {
    [ -e "${ZSH_AI_JCODE_BIN_PATH}" ] && export PATH="${ZSH_AI_JCODE_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::jcode::install {
    if core::exists jcode; then
        return 0
    fi

    message_info "Installing jcode..."
    if curl -fsSL "${ZSH_AI_JCODE_INSTALL_URL}" | bash; then
        message_success "jcode installed successfully"
    else
        message_error "Failed to install jcode"
        return 1
    fi
}

function ai::internal::jcode::sync {
    if ! core::exists rsync; then
        message_error "rsync is not installed"
        return 1
    fi

    message_info "Syncing jcode config from ${ZSH_AI_JCODE_CONFIG_SOURCE_PATH} to ${ZSH_AI_JCODE_CONFIG_PATH}..."

    mkdir -p "${ZSH_AI_JCODE_CONFIG_PATH}"

    rsync -avzh --progress "${ZSH_AI_JCODE_CONFIG_SOURCE_PATH}/" "${ZSH_AI_JCODE_CONFIG_PATH}/"

}
