# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::graphify::load {
    [ -e "${AI_GRAPHIFY_BIN_PATH}/graphify" ] && export PATH="${AI_GRAPHIFY_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::graphify::install {
    if core::exists graphify; then
        return 0
    fi

    if ! core::exists uv; then
        message_error "uv is not installed. Please install uv first: curl -LsSf https://astral.sh/uv/install.sh | sh"
        return 1
    fi

    message_info "Installing graphify..."
    if uv tool install "graphifyy[all]" --force; then
        message_success "graphify installed successfully"
    else
        message_error "Failed to install graphify"
        return 1
    fi
}

function ai::internal::graphify::upgrade {
    if ! core::exists uv; then
        message_error "uv is not installed. Please install uv first: curl -LsSf https://astral.sh/uv/install.sh | sh"
        return 1
    fi

    message_info "Upgrading graphify..."
    if uv tool install "graphifyy[all]" --force; then
        message_success "graphify upgraded successfully"
    else
        message_error "Failed to upgrade graphify"
        return 1
    fi
}

function ai::internal::graphify::init {
    if ! core::exists graphify; then
        message_error "graphify is not installed. Run ai::graphify::install first."
        return 1
    fi
    message_info "Initializing graphify..."

    if graphify install --platform opencode --project; then
        message_success "graphify initialized successfully"
    else
        message_error "Failed to initialize graphify"
        return 1
    fi
}

function ai::internal::graphify::update {
    if ! core::exists graphify; then
        message_error "graphify is not installed. Run ai::graphify::install first."
        return 1
    fi
    message_info "Updating graphify..."
    if graphify update; then
        message_success "graphify updated successfully"
    else
        message_error "Failed to update graphify"
        return 1
    fi
}

function ai::internal::graphify::setup {
    if ! core::exists graphify; then
        message_error "graphify is not installed. Run ai::graphify::install first."
        return 1
    fi

    message_info "Setting up graphify for current project..."

    if [[ ! -d "graphify-out" ]]; then
        ai::internal::graphify::init
        return
    fi

    ai::internal::graphify::update
}