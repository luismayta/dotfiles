# shellcheck shell=bash
#
# Internal core logic for the nvim module.
# Implements nvimrc sync, install, upgrade, and cache cleanup.
# Follows the same pattern as zsh/modules/hyprland/internal/base.zsh.

function nvim::internal::sync {
    message_info "Syncing nvimrc configuration..."
    command mkdir -p "${NVIM_CONFIG_PATH}"
    command rsync -avzh --progress \
        "${NVIM_PATH}/data/" \
        "${NVIM_CONFIG_PATH}/"
    message_success "Synced nvimrc configuration"
}

function nvim::internal::install {
    nvim::internal::sync "$@"
}

function nvim::internal::upgrade {
    nvim::internal::sync "$@"
}

function nvim::internal::clean {
    message_info "Cleaning nvim caches..."
    command rm -rf \
        "${HOME}/.local/share/nvim" \
        "${HOME}/.cache/nvim" \
        "${HOME}/.local/state/nvim" \
        2>/dev/null || true
    message_success "Cleaned nvim caches"
}
