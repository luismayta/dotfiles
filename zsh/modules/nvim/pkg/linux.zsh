# shellcheck shell=bash
#
# Linux-specific public API for nvim module.
# Wraps clean to use XDG paths defined in internal/linux.zsh.

function nvim::clean::xdg {
    message_info "Cleaning nvim XDG directories..."
    command rm -rf \
        "${NVIM_DATA_HOME}" \
        "${NVIM_CACHE_HOME}" \
        "${NVIM_STATE_HOME}" \
        2>/dev/null || true
    message_success "Cleaned nvim XDG directories"
}
