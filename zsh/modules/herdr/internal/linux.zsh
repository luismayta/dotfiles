# shellcheck shell=bash
# Linux-specific internal helpers

function hrd::internal::linux::ensure_clipboard {
    if core::exists xclip; then
        return 0
    fi

    if core::exists wl-copy; then
        return 0
    fi

    message_info "Installing clipboard tools for Linux..."

    if core::exists apt-get; then
        core::install xclip
    elif core::exists dnf; then
        core::install xclip
    elif core::exists pacman; then
        core::install xclip
    else
        message_warning "Could not install clipboard tools. Install xclip or wl-clipboard manually."
        return 1
    fi

    message_success "Clipboard tools installed."
}
