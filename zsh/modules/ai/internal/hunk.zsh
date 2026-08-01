# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::hunk::load {
    [ -e "${ZSH_AI_HUNK_BIN_PATH}/hunk" ] && export PATH="${ZSH_AI_HUNK_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::hunk::install {
    if core::exists hunk; then
        return 0
    fi

    if ! core::exists npm; then
        message_error "npm is not installed"
        return 1
    fi

    message_info "Installing hunk..."
    if npm install -g hunkdiff; then
        message_success "hunk installed successfully"
    else
        message_error "Failed to install hunk"
        return 1
    fi
}
