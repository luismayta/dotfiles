# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::opencode::load {
    [ -e "${AI_OPENCODE_BIN_PATH}" ] && export PATH="${AI_OPENCODE_BIN_PATH}:${PATH}"
}

function ai::internal::opencode::sync_quiet {
    mkdir -p "${AI_OPENCODE_CONFIG_PATH}" "${AI_OPENCODE_RUNTIME_CONFIG_PATH}"
    rsync -a "${AI_OPENCODE_CONFIG_SOURCE_PATH}/" "${AI_OPENCODE_CONFIG_PATH}/" \
        && rsync -a --exclude "node_modules" "${AI_OPENCODE_RUNTIME_SOURCE_PATH}/" "${AI_OPENCODE_RUNTIME_CONFIG_PATH}/"
}

function ai::internal::shimmy::load {
    [ -e "${AI_SHIMMY_BIN_PATH}" ] && export PATH="${AI_SHIMMY_BIN_PATH}:${PATH}"
}

function ai::internal::openclaw::load {
    [ -e "${AI_OPENCLAW_BIN_PATH}" ] && export PATH="${AI_OPENCLAW_BIN_PATH}:${PATH}"
}

function ai::internal::codegraph::load {
    [ -e "${AI_CODEGRAPH_BIN_PATH}/codegraph" ] && export PATH="${AI_CODEGRAPH_BIN_PATH}:${PATH}"
}

# === Batch Install ===

function ai::internal::packages::install {
    message_info "Installing required ai packages"
    for package in "${AI_TOOLS[@]}"; do
        case "${package}" in
            opencode)
                ai::internal::opencode::install
                ;;
            fabric)
                ai::internal::fabric::install
                ;;
            ollama)
                ai::internal::ollama::install
                ;;
            shimmy)
                ai::internal::shimmy::install
                ;;
            hf)
                ai::internal::hf::install
                ;;
            openclaw)
                ai::internal::openclaw::install
                ;;
            codegraph)
                ai::internal::codegraph::install
                ;;
            tmuxai)
                ai::internal::tmuxai::install
                ;;
            *)
                core::install "${package}"
                ;;
        esac
    done
    message_success "Installed required ai packages"
}

# === Tool Install Functions ===

function ai::internal::opencode::install {
    if core::exists opencode; then
        return 0
    fi

    message_info "Installing opencode..."
    if curl -fsSL "${AI_INSTALL_URL_OPENCODE}" | bash; then
        message_success "opencode installed successfully"
    else
        message_error "Failed to install opencode"
        return 1
    fi
}

function ai::internal::opencode::sync {
    if ! core::exists rsync; then
        message_error "rsync is not installed"
        return 1
    fi

    message_info "Syncing opencode config from ${AI_OPENCODE_CONFIG_SOURCE_PATH} to ${AI_OPENCODE_CONFIG_PATH}..."

    if ai::internal::opencode::sync_quiet; then
        message_success "opencode config synced successfully"
    else
        message_error "Failed to sync opencode config"
        return 1
    fi
}

function ai::internal::fabric::install {
    if core::exists fabric; then
        return 0
    fi

    message_info "Installing fabric..."
    if curl -fsSL "${AI_INSTALL_URL_FABRIC}" | bash; then
        message_success "fabric installed successfully"
    else
        message_error "Failed to install fabric"
        return 1
    fi
}

function ai::internal::ollama::install {
    if core::exists ollama; then
        return 0
    fi

    message_info "Installing ollama..."
    if curl -fsSL "${AI_INSTALL_URL_OLLAMA}" | sh; then
        message_success "ollama installed successfully"
    else
        message_error "Failed to install ollama"
        return 1
    fi
}

function ai::internal::shimmy::install {
    if core::exists shimmy; then
        return 0
    fi

    mkdir -p "${AI_SHIMMY_BIN_PATH}"

    if curl -fsSL "${AI_INSTALL_URL_SHIMMY}" -o "${AI_SHIMMY_BIN_PATH}/shimmy"; then
        chmod +x "${AI_SHIMMY_BIN_PATH}/shimmy"
        message_success "shimmy installed successfully"
    else
        message_error "Failed to install shimmy"
        return 1
    fi
}

function ai::internal::hf::install {
    if core::exists hf; then
        return 0
    fi

    message_info "Installing hf CLI..."
    if curl -fsSL "${AI_INSTALL_URL_HF}" | bash; then
        message_success "hf installed successfully"
    else
        message_error "Failed to install hf"
        return 1
    fi
}

function ai::internal::openclaw::install {
    if core::exists openclaw; then
        return 0
    fi

    mkdir -p "${AI_OPENCLAW_BIN_PATH}"

    message_info "Installing openclaw..."

    if curl -fsSL "${AI_INSTALL_URL_OPENCLAW}" | bash; then
        message_success "openclaw installed successfully"
    else
        message_error "Failed to install openclaw"
        return 1
    fi
}

function ai::internal::codegraph::install {
    if core::exists codegraph; then
        return 0
    fi

    message_info "Installing codegraph..."
    if curl -fsSL "${AI_INSTALL_URL_CODEGRAPH}" | sh; then
        message_success "codegraph installed successfully"
    else
        message_error "Failed to install codegraph"
        return 1
    fi
}

function ai::internal::tmuxai::install {
    if core::exists tmuxai; then
        return 0
    fi

    if ! core::exists curl; then
        message_error "curl is not installed"
        return 1
    fi

    if ! core::exists bash; then
        message_error "bash is not installed"
        return 1
    fi

    message_info "Installing tmuxai..."
    if curl -fsSL "${AI_INSTALL_URL_TMUXAI}" | bash; then
        message_success "tmuxai installed successfully"
    else
        message_error "Failed to install tmuxai"
        return 1
    fi
}
