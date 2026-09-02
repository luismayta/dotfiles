# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::archify::load {
    [ -e "${ZSH_AI_ARCHIFY_BIN_PATH}/archify" ] && export PATH="${ZSH_AI_ARCHIFY_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::archify::install {
    if core::exists archify; then
        return 0
    fi

    if ! core::exists bunx; then
        message_error "bunx is not installed"
        return 1
    fi

    message_info "Installing archify..."
    if bunx skills add tt-a1i/archify -g; then
        message_success "archify installed successfully"
    else
        message_error "Failed to install archify"
        return 1
    fi
}

# === Health Check ===

function ai::internal::archify::setup {
    if ! core::exists archify; then
        message_error "archify is not installed"
        return 1
    fi

    message_info "Running archify doctor..."
    archify doctor
}
