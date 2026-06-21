# shellcheck shell=bash
#
# Internal core logic for the nvim module.
# Implements nvimrc sync, install, upgrade, and cache cleanup.
# Follows the same pattern as zsh/modules/hyprland/internal/base.zsh.

function nvim::internal::backup {
    local exclude_opts=(
        --exclude=".git/"
        --exclude="node_modules/"
        --exclude=".lazy/"
        --exclude=".cache/"
    )
    if [[ "$1" == "--apply" ]]; then
        command rsync -av --delete "${exclude_opts[@]}" "${NVIM_CONFIG_PATH}/" "${NVIM_PATH}/data/"
        message_success "nvim: backup restored to data/"
    else
        command rsync -av --delete --dry-run "${exclude_opts[@]}" "${NVIM_CONFIG_PATH}/" "${NVIM_PATH}/data/"
        message_info "nvim: backup dry-run — pass --apply to execute"
    fi
}

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
    nvim --headless -c "lua require('mason').setup() require('mason-lspconfig').setup({ automatic_installation = true })" -c "MasonInstallAll" -c "qa"
    message_success "nvim: plugin installed/updated"
}

function nvim::internal::upgrade {
    nvim::internal::sync "$@"
    nvim --headless "+Lazy! sync" +qa
    message_success "nvim: plugins upgraded"
}

function nvim::internal::clean {
    message_info "Cleaning nvim caches..."
    command rm -rf \
        "${NVIM_DATA_HOME}" \
        "${NVIM_CACHE_HOME}" \
        "${NVIM_STATE_HOME}" \
        2>/dev/null || true
    message_success "Cleaned nvim caches"
}
