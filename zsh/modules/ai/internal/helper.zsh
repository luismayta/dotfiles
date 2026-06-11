# shellcheck shell=bash

# === Fabric Helpers ===

function ai::internal::fabric::patterns::sync {
    if [[ ! -d "${AI_FABRIC_PATTERNS_SYNC_SOURCE}" ]]; then
        message_warning "Patterns source directory not found: ${AI_FABRIC_PATTERNS_SYNC_SOURCE}"
        return 1
    fi

    message_info "Syncing patterns from ${AI_FABRIC_PATTERNS_SYNC_SOURCE} to ${AI_FABRIC_PATTERNS_PATH}..."

    mkdir -p "${AI_FABRIC_PATTERNS_PATH}"

    if rsync -av --delete "${AI_FABRIC_PATTERNS_SYNC_SOURCE}/" "${AI_FABRIC_PATTERNS_PATH}/"; then
        message_success "Patterns synced successfully"
    else
        message_error "Failed to sync patterns"
        return 1
    fi
}

function ai::internal::fabric::patterns::pull {
    if core::exists fabric; then
        message_info "Updating fabric patterns..."
        fabric --updatepatterns
        message_success "Patterns updated"
    else
        message_error "fabric is not installed"
        return 1
    fi
}

# === Ollama Helpers ===

function ai::internal::ollama::models::list {
    if ! core::exists ollama; then
        message_error "ollama is not installed"
        return 1
    fi

    message_info "Listing ollama models..."
    ollama list
}

function ai::internal::ollama::models::pull {
    if ! core::exists ollama; then
        message_error "ollama is not installed"
        return 1
    fi

    local model="${1}"
    if [[ -z "${model}" ]]; then
        message_error "Model name required: ai::ollama::models::pull <model>"
        return 1
    fi

    message_info "Pulling model: ${model}..."
    ollama pull "${model}"
}

function ai::internal::ollama::models::install {
    if ! core::exists ollama; then
        message_error "ollama is not installed"
        return 1
    fi

    message_info "Installing default ollama models..."
    for model in "${AI_OLLAMA_MODELS[@]}"; do
        message_info "Pulling model: ${model}..."
        ollama pull "${model}"
    done
    message_success "All default models installed"
}
