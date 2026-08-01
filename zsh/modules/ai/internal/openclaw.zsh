# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::openclaw::load {
    [ -e "${ZSH_AI_OPENCLAW_BIN_PATH}" ] && export PATH="${ZSH_AI_OPENCLAW_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::openclaw::install {
    if core::exists openclaw; then
        return 0
    fi

    mkdir -p "${ZSH_AI_OPENCLAW_BIN_PATH}"

    message_info "Installing openclaw..."

    if curl -fsSL "${ZSH_AI_INSTALL_URL_OPENCLAW}" | bash; then
        message_success "openclaw installed successfully"
    else
        message_error "Failed to install openclaw"
        return 1
    fi
}
