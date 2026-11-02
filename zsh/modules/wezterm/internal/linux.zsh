# shellcheck shell=bash
# Linux-specific wezterm internals

function wezterm::internal::install {
    if core::exists wezterm; then
        return 0
    fi
    message_info "Installing ${WEZTERM_PACKAGE_NAME}..."
    # wezterm-git is the AUR package name (distinct from the display name)
    if ! core::install wezterm-git; then
        message_error "Failed to install ${WEZTERM_PACKAGE_NAME}"
        return 1
    fi
    message_success "${WEZTERM_PACKAGE_NAME} installed successfully."
}