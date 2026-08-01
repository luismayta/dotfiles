# shellcheck shell=bash

# === Tool Install ===

function ai::internal::tmuxai::install {
    if core::exists tmuxai; then
        return 0
    fi

    if ! core::exists curl; then
        message_error "curl is not installed"
        return 1
    fi

    if ! core::exists bash; then
        message_error "bash is not installed"
        return 1
    fi

    message_info "Installing tmuxai..."
    if curl -fsSL "${ZSH_AI_INSTALL_URL_TMUXAI}" | bash; then
        message_success "tmuxai installed successfully"
    else
        message_error "Failed to install tmuxai"
        return 1
    fi
}
