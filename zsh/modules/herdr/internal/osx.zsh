# shellcheck shell=bash
# macOS-specific internal helpers

function hrd::internal::osx::ensure_clipboard {
    # pbcopy/pbpaste are built into macOS, nothing to install
    :
}

# ──────────────────────────────────────────────
# Custom CLI dependencies — macOS strategy
# ──────────────────────────────────────────────

function herdr::internal::deps::install::espresso {
    core::ensure curl

    message_info "Installing espresso CLI..."
    if curl -fsSL "${ZSH_HERDR_ESPRESSO_INSTALL_URL}" | sh; then
        if core::exists espresso; then
            message_success "espresso CLI installed successfully"
            return 0
        fi
        message_warning "espresso install script ran but binary not found in PATH"
    fi

    message_error "Failed to install espresso CLI"
    return 1
}

function herdr::internal::espresso::daemon::install {
    if ! core::exists espresso; then
        message_error "espresso CLI not found — run herdr::espresso::install first"
        return 1
    fi

    message_info "Installing espresso daemon (requires sudo)..."
    if espresso daemon install; then
        message_success "espresso daemon installed successfully"
        return 0
    fi

    message_error "Failed to install espresso daemon"
    return 1
}
