# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::codegraph::load {
    [ -e "${ZSH_AI_CODEGRAPH_BIN_PATH}/codegraph" ] && export PATH="${ZSH_AI_CODEGRAPH_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::codegraph::install {
    if core::exists codegraph; then
        return 0
    fi

    message_info "Installing codegraph..."
    if curl -fsSL "${ZSH_AI_INSTALL_URL_CODEGRAPH}" | sh; then
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

function ai::internal::codegraph::update {
    if ! core::exists codegraph; then
        message_error "codegraph is not installed. Run ai::codegraph::install first."
        return 1
    fi
    message_info "Updating index codegraph..."
    if codegraph index; then
        message_success "codegraph project index complete"
    else
        message_error "Failed to index codegraph for project"
        return 1
    fi
}

function ai::internal::codegraph::upgrade {
    if ! core::exists codegraph; then
        message_error "codegraph is not installed. Run ai::codegraph::install first."
        return 1
    fi
    message_info "Upgrading codegraph..."
    if curl -fsSL "${ZSH_AI_INSTALL_URL_CODEGRAPH}" | sh; then
        message_success "codegraph upgraded successfully"
    else
        message_error "Failed to upgrade codegraph"
        return 1
    fi
}

function ai::internal::codegraph::setup {
    if ! core::exists codegraph; then
        message_error "codegraph is not installed. Run ai::codegraph::install first."
        return 1
    fi

    message_info "Setting up codegraph for current project..."

    if [[ ! -f .codegraph/codegraph.db ]]; then
        if ! ai::internal::codegraph::init; then
            message_error "Failed to initialize codegraph for project"
            return 1
        fi
    else
        if ! ai::internal::codegraph::update; then
            message_error "Failed to update codegraph for project"
            return 1
        fi
    fi

    message_success "codegraph project setup complete"
}