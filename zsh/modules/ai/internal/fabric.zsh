# shellcheck shell=bash

# === Fabric Install ===

function ai::internal::fabric::install {
    if core::exists fabric; then
        return 0
    fi

    message_info "Installing fabric..."
    if curl -fsSL "${AI_INSTALL_URL_FABRIC}" | bash; then
        message_success "fabric installed successfully"
    else
        message_error "Failed to install fabric"
        return 1
    fi
}

# === Fabric Patterns ===

function ai::internal::fabric::patterns::sync {
    if [[ ! -d "${AI_FABRIC_PATTERNS_SYNC_SOURCE}" ]]; then
        message_warning "Patterns source directory not found: ${AI_FABRIC_PATTERNS_SYNC_SOURCE}"
        return 1
    fi

    message_info "Syncing patterns from ${AI_FABRIC_PATTERNS_SYNC_SOURCE} to ${AI_FABRIC_PATTERNS_PATH}..."

    mkdir -p "${AI_FABRIC_PATTERNS_PATH}"

    if rsync -av --delete "${AI_FABRIC_PATTERNS_SYNC_SOURCE}/" "${AI_FABRIC_PATTERNS_PATH}/"; then
        message_success "Patterns synced successfully"
    else
        message_error "Failed to sync patterns"
        return 1
    fi
}

function ai::internal::fabric::patterns::pull {
    if core::exists fabric; then
        message_info "Updating fabric patterns..."
        fabric --updatepatterns
        message_success "Patterns updated"
    else
        message_error "fabric is not installed"
        return 1
    fi
}
