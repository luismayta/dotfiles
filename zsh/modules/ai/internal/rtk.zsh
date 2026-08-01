# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::rtk::load {
    [ -e "${ZSH_AI_RTK_BIN_PATH}/rtk" ] && export PATH="${ZSH_AI_RTK_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::rtk::install {
    if core::exists rtk; then
        return 0
    fi

    message_info "Installing rtk..."
    if curl -fsSL "${ZSH_AI_INSTALL_URL_RTK}" | sh; then
        message_success "rtk installed successfully"
    else
        message_error "Failed to install rtk"
        return 1
    fi
}

# === Config Sync ===

function ai::internal::rtk::config::sync {
    local src="${ZSH_AI_RTK_CONFIG_SOURCE_PATH}"
    local dst="${ZSH_AI_RTK_CONFIG_PATH}"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        rsync -a "$src/" "$dst/"
        message_success "rtk config synced"
    else
        message_warning "no rtk config source at ${src}"
    fi
}
