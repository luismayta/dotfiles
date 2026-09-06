# shellcheck shell=bash

# === PATH Loading ===

function ai::internal::omp::load {
    [ -e "${ZSH_AI_OMP_BIN_PATH}/omp" ] && export PATH="${ZSH_AI_OMP_BIN_PATH}:${PATH}"
}

# === Tool Install ===

function ai::internal::omp::install {
    if core::exists omp; then
        return 0
    fi

    message_info "Installing omp (AI coding agent)..."
    if curl -fsSL "${ZSH_AI_OMP_INSTALL_URL}" | sh; then
        message_success "omp installed successfully"
    else
        message_error "Failed to install omp"
        return 1
    fi
}

# === Config Sync ===

function ai::internal::omp::config::sync {
    local src="${ZSH_AI_OMP_CONFIG_SOURCE_PATH}"
    local dst="${ZSH_AI_OMP_CONFIG_PATH}"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        rsync -a "$src/" "$dst/"
        message_success "omp config synced"
    else
        message_warning "no omp config source at ${src}"
    fi
}
