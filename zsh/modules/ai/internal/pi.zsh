# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::pi::load {
    [ -e "${ZSH_AI_PI_BIN_PATH}/pi" ] && export PATH="${ZSH_AI_PI_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::pi::install {
    if core::exists pi; then
        return 0
    fi

    message_info "Installing pi (AI coding agent)..."
    if curl -fsSL "${ZSH_AI_INSTALL_URL_PI}" | sh; then
        message_success "pi installed successfully"
    else
        message_error "Failed to install pi"
        return 1
    fi
}

# === Config Sync ===

function ai::internal::pi::config::sync {
    local src="${ZSH_AI_PI_CONFIG_SOURCE_PATH}"
    local dst="${ZSH_AI_PI_CONFIG_PATH}"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        rsync -a "$src/" "$dst/"
        message_success "pi config synced"
    else
        message_warning "no pi config source at ${src}"
    fi
}
