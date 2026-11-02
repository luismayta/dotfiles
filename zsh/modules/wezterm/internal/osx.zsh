# shellcheck shell=bash
# macOS-specific wezterm internals

function wezterm::internal::install {
    if core::exists wezterm; then
        return 0
    fi
    message_info "Installing ${WEZTERM_PACKAGE_NAME}..."
    if ! core::install --cask "${WEZTERM_PACKAGE_NAME}"; then
        message_error "Failed to install ${WEZTERM_PACKAGE_NAME}"
        return 1
    fi
    message_success "${WEZTERM_PACKAGE_NAME} installed successfully."
}