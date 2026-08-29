# shellcheck shell=bash

function bitwarden::internal::bitwarden::install {
    if core::exists bw; then
        message_info "${BITWARDEN_PACKAGE_NAME} already installed"
        return 0
    fi

    if ! core::exists bun; then
        message_error "bun is required to install ${BITWARDEN_PACKAGE_NAME}"
        return 1
    fi

    message_info "Installing ${BITWARDEN_PACKAGE_NAME}"
    bun install -g @bitwarden/cli
    message_success "Installed ${BITWARDEN_PACKAGE_NAME}"
}

function bitwarden::internal::bitwarden::upgrade {
    if ! core::exists bw; then
        bitwarden::internal::bitwarden::install
        return
    fi

    message_info "Upgrading ${BITWARDEN_PACKAGE_NAME}"
    bun install -g @bitwarden/cli
    message_success "Upgraded ${BITWARDEN_PACKAGE_NAME}"
}

function bitwarden::internal::load::env {
    # Check env-secrets is available
    if ! core::exists env-secrets; then
        message_warning "env-secrets not found. Install with: go install github.com/sganon/env-secrets@latest"
        return 1
    fi

    # Return silently if list is empty or unset
    if [[ -z "${BITWARDEN_VARS_LIST}" ]] || [[ ${#BITWARDEN_VARS_LIST[@]} -eq 0 ]]; then
        return 0
    fi

    # Single vault: auto-select
    local selected
    if [[ ${#BITWARDEN_VARS_LIST[@]} -eq 1 ]]; then
        selected="${BITWARDEN_VARS_LIST[1]}"
    elif core::exists fzf; then
        # Multiple vaults: use fzf
        selected=$(
            printf "%s\n" "${BITWARDEN_VARS_LIST[@]}" \
                | fzf --prompt "Select Bitwarden vault: " --height 40% --reverse
        )
    else
        # fzf not available, fall back to first vault
        selected="${BITWARDEN_VARS_LIST[1]}"
    fi

    # If user cancelled fzf, return silently
    [[ -n "$selected" ]] || return 0

    # Delegate to env-secrets
    eval "$(env-secrets bw "${selected}")"
}
