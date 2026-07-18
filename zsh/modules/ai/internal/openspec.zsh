# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::openspec::load {
    true
}

# === Tool Install ===

function ai::internal::openspec::install {
    if core::exists openspec; then
        return 0
    fi

    if ! core::exists bun; then
        message_error "bun is not installed"
        return 1
    fi

    message_info "Installing openspec..."
    if bun add -g @fission-ai/openspec@latest; then
        message_success "openspec installed successfully"
        ai::internal::openspec::register_skill
    else
        message_error "Failed to install openspec"
        return 1
    fi
}

function ai::internal::openspec::upgrade {
    if ! core::exists bun; then
        message_error "bun is not installed"
        return 1
    fi

    message_info "Upgrading openspec..."
    if bun add -g @fission-ai/openspec@latest --force; then
        message_success "openspec upgraded successfully"
        ai::internal::openspec::register_skill
    else
        message_error "Failed to upgrade openspec"
        return 1
    fi
}

function ai::internal::openspec::register_skill {
    if core::exists openspec; then
        message_info "Registering openspec skill with OpenCode..."
        if openspec install --platform opencode; then
            message_success "openspec skill registered"
        else
            message_warning "Failed to register openspec skill (openspec is still installed)"
        fi
    fi
}

function ai::internal::openspec::init {
    if ! core::exists openspec; then
        message_error "openspec is not installed. Run ai::openspec::install first."
        return 1
    fi
    message_info "Initializing OpenSpec..."
    if openspec init --tools opencode; then
        message_success "openspec initialized successfully"
    else
        message_error "Failed to initialize openspec"
        return 1
    fi
}

function ai::internal::openspec::update {
    if ! core::exists openspec; then
        message_error "openspec is not installed. Run ai::openspec::install first."
        return 1
    fi
    message_info "Updating OpenSpec..."
    if openspec update; then
        message_success "openspec updated successfully"
    else
        message_error "Failed to update openspec"
        return 1
    fi
}

function ai::internal::openspec::setup {
    if ! core::exists openspec; then
        message_error "openspec is not installed. Run ai::openspec::install first."
        return 1
    fi
    message_info "Setting up openspec for current project..."
    if [[ -d ".openspec" ]]; then
        ai::internal::openspec::update
    else
        ai::internal::openspec::init
    fi
}
