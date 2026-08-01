# shellcheck shell=bash

# === Tool Install ===

function ai::internal::hf::install {
    if core::exists hf; then
        return 0
    fi

    message_info "Installing hf CLI..."
    if curl -fsSL "${ZSH_AI_INSTALL_URL_HF}" | bash; then
        message_success "hf installed successfully"
    else
        message_error "Failed to install hf"
        return 1
    fi
}
