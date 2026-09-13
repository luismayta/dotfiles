#!/usr/bin/env ksh

# === PATH Loading ===

function ai::internal::tuicr::load {
    if core::exists tuicr; then
        export PATH="${ZSH_AI_TUICR_BIN_PATH}:${PATH}"
    fi
}

# === Tool Install ===

function ai::internal::tuicr::install {
    if core::exists tuicr; then
        return 0
    fi

    if ! core::exists curl; then
        message_error "curl is not installed"
        return 1
    fi

    message_info "Installing tuicr..."
    if curl -fsSL "${ZSH_AI_TUICR_INSTALL_URL}" | sh; then
        message_success "tuicr installed successfully"
    else
        message_error "Failed to install tuicr"
        return 1
    fi
}

# === Load ===

ai::internal::tuicr::load
