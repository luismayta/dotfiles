# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::shimmy::load {
    [ -e "${ZSH_AI_SHIMMY_BIN_PATH}" ] && export PATH="${ZSH_AI_SHIMMY_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::shimmy::install {
    if core::exists shimmy; then
        return 0
    fi

    mkdir -p "${ZSH_AI_SHIMMY_BIN_PATH}"

    if curl -fsSL "${ZSH_AI_INSTALL_URL_SHIMMY}" -o "${ZSH_AI_SHIMMY_BIN_PATH}/shimmy"; then
        chmod +x "${ZSH_AI_SHIMMY_BIN_PATH}/shimmy"
        message_success "shimmy installed successfully"
    else
        message_error "Failed to install shimmy"
        return 1
    fi
}
