# shellcheck shell=bash

# === Ollama Install ===

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

# === Ollama Models ===

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
