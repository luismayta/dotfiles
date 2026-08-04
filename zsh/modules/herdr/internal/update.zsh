# shellcheck shell=bash

# ──────────────────────────────────────────────
# Update helpers
# ──────────────────────────────────────────────

function herdr::internal::update {
    core::ensure curl

    message_info "Updating ${ZSH_HERDR_PACKAGE_NAME}..."
    if curl -fsSL "${ZSH_HERDR_INSTALL_URL}" | sh; then
        if core::exists herdr; then
            message_success "${ZSH_HERDR_PACKAGE_NAME} updated successfully"
            return 0
        fi
        message_warning "${ZSH_HERDR_PACKAGE_NAME} update script ran but binary not found in PATH"
    fi

    message_error "Failed to update ${ZSH_HERDR_PACKAGE_NAME}"
    return 1
}