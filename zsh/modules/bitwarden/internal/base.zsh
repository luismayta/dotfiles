# shellcheck shell=bash

function bitwarden::internal::bitwarden::install {
    message_info "Installing bitwarden cli"
    if core::exists yarn; then
        yarn global add @bitwarden/cli
        message_success "Installed @bitwarden/cli"
    else
        message_warning "Please install yarn or npm to install @bitwarden/cli"
    fi
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
