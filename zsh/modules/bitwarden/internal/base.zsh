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
    if [[ -f "${HOME}/.bw_env" ]]; then
        # shellcheck source=/dev/null
        source "${HOME}/.bw_env"
    fi
}
