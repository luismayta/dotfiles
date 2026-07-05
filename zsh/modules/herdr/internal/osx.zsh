# shellcheck shell=bash
# macOS-specific internal helpers

function hrd::internal::osx::ensure_clipboard {
    # pbcopy/pbpaste are built into macOS, nothing to install
    if ! core::exists reattach-to-user-namespace; then
        message_info "reattach-to-user-namespace is recommended for tmux/terminal clipboard integration."
        message_info "Install with: brew install reattach-to-user-namespace"
    fi
}
