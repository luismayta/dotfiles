# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::shimmy::load {
    [ -e "${AI_SHIMMY_BIN_PATH}" ] && export PATH="${AI_SHIMMY_BIN_PATH}:${PATH}"
}

function ai::internal::openclaw::load {
    [ -e "${AI_OPENCLAW_BIN_PATH}" ] && export PATH="${AI_OPENCLAW_BIN_PATH}:${PATH}"
}

function ai::internal::codegraph::load {
    [ -e "${AI_CODEGRAPH_BIN_PATH}/codegraph" ] && export PATH="${AI_CODEGRAPH_BIN_PATH}:${PATH}"
}

function ai::internal::rtk::load {
    [ -e "${AI_RTK_BIN_PATH}/rtk" ] && export PATH="${AI_RTK_BIN_PATH}:${PATH}"
}

function ai::internal::hunk::load {
    [ -e "${AI_HUNK_BIN_PATH}/hunk" ] && export PATH="${AI_HUNK_BIN_PATH}:${PATH}"
}

function ai::internal::pi::load {
    [ -e "${AI_PI_BIN_PATH}/pi" ] && export PATH="${AI_PI_BIN_PATH}:${PATH}"
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
            rtk)
                ai::internal::rtk::install
                ;;
            hunk)
                ai::internal::hunk::install
                ;;
            pi)
                ai::internal::pi::install
                ;;
            graphify)
                ai::internal::graphify::install
                ;;
            skills)
                ai::internal::skills::install
                ;;
            *)
                core::install "${package}"
                ;;
        esac
    done
    message_success "Installed required ai packages"
}

# === Tool Install Functions ===

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

function ai::internal::codegraph::init {
    if ! core::exists codegraph; then
        message_error "codegraph is not installed. Run ai::codegraph::install first."
        return 1
    fi
    message_info "Initializing codegraph..."
    if codegraph init; then
        message_success "codegraph initialized successfully"
    else
        message_error "Failed to initialize codegraph"
        return 1
    fi
}

function ai::internal::codegraph::setup {
    if ! core::exists codegraph; then
        message_error "codegraph is not installed. Run ai::codegraph::install first."
        return 1
    fi
    message_info "Setting up codegraph for current project..."
    if codegraph init; then
        message_success "codegraph project setup complete"
    else
        message_error "Failed to set up codegraph for project"
        return 1
    fi
}

function ai::internal::codegraph::update {
    if ! core::exists codegraph; then
        message_error "codegraph is not installed. Run ai::codegraph::install first."
        return 1
    fi
    message_info "Updating codegraph..."
    if curl -fsSL "${AI_INSTALL_URL_CODEGRAPH}" | sh; then
        message_success "codegraph updated successfully"
    else
        message_error "Failed to update codegraph"
        return 1
    fi
}

function ai::internal::codegraph::upgrade {
    if ! core::exists codegraph; then
        message_error "codegraph is not installed. Run ai::codegraph::install first."
        return 1
    fi
    message_info "Upgrading codegraph..."
    if curl -fsSL "${AI_INSTALL_URL_CODEGRAPH}" | sh; then
        message_success "codegraph upgraded successfully"
    else
        message_error "Failed to upgrade codegraph"
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

function ai::internal::rtk::install {
    if core::exists rtk; then
        return 0
    fi

    message_info "Installing rtk..."
    if curl -fsSL "${AI_INSTALL_URL_RTK}" | sh; then
        message_success "rtk installed successfully"
    else
        message_error "Failed to install rtk"
        return 1
    fi
}

function ai::internal::hunk::install {
    if core::exists hunk; then
        return 0
    fi

    if ! core::exists npm; then
        message_error "npm is not installed"
        return 1
    fi

    message_info "Installing hunk..."
    if npm install -g hunkdiff; then
        message_success "hunk installed successfully"
    else
        message_error "Failed to install hunk"
        return 1
    fi
}

function ai::internal::pi::install {
    if core::exists pi; then
        return 0
    fi

    message_info "Installing pi (AI coding agent)..."
    if curl -fsSL "${AI_INSTALL_URL_PI}" | sh; then
        message_success "pi installed successfully"
    else
        message_error "Failed to install pi"
        return 1
    fi
}

# === Config Syncs ===

function ai::internal::rtk::config::sync {
    local src="${AI_RTK_CONFIG_SOURCE_PATH}"
    local dst="${AI_RTK_CONFIG_PATH}"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        rsync -a "$src/" "$dst/"
        message_success "rtk config synced"
    else
        message_warning "no rtk config source at ${src}"
    fi
}

function ai::internal::pi::config::sync {
    local src="${AI_PI_CONFIG_SOURCE_PATH}"
    local dst="${AI_PI_CONFIG_PATH}"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        rsync -a "$src/" "$dst/"
        message_success "pi config synced"
    else
        message_warning "no pi config source at ${src}"
    fi
}
