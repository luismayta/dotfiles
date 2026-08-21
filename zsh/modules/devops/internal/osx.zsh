# shellcheck shell=bash
# macOS-specific devops internal functions

function devops::gcloud::internal::install {
    message_info "Installing google-cloud-cli"
    if ! brew install --cask google-cloud-cli; then
        message_error "Failed to install google-cloud-cli"
        return 1
    fi
    message_success "Installed google-cloud-cli"
}

function devops::bruno::internal::bru::install {
    if ! core::exists bun; then
        message_error "bun is required to install ${DEVOPS_BRUNO_PACKAGE_NAME}"
        return 1
    fi
    message_info "Installing ${DEVOPS_BRUNO_PACKAGE_NAME} CLI"
    if ! "${=DEVOPS_BRUNO_INSTALL_CMD}" "${DEVOPS_BRUNO_CLI_PACKAGE}"; then
        message_error "Failed to install ${DEVOPS_BRUNO_PACKAGE_NAME} CLI"
        return 1
    fi
    message_success "Installed ${DEVOPS_BRUNO_PACKAGE_NAME} CLI"
}

function devops::direnv::internal::install {
    if devops::direnv::internal::is_managed && core::exists direnv; then
        message_success "direnv/nix-direnv already available; skipping install"
        return 0
    fi
    if ! core::exists direnv; then
        message_info "Installing direnv"
        if ! nix profile add "nixpkgs#direnv" --extra-experimental-features 'nix-command flakes'; then
            message_error "Failed to install direnv"
            return 1
        fi
    fi
    if ! devops::direnv::internal::is_managed; then
        message_info "Installing nix-direnv plugin"
        if ! nix profile add "${DEVOPS_DIRENV_NIX_DIRENV_PACKAGE}" --extra-experimental-features 'nix-command flakes'; then
            message_error "Failed to install nix-direnv"
            return 1
        fi
        message_success "Installed nix-direnv"
    fi
}

function devops::direnv::internal::upgrade {
    message_info "Upgrading ${DEVOPS_DIRENV_PACKAGE_NAME:-direnv}"
    if ! nix profile upgrade nix-direnv --extra-experimental-features 'nix-command flakes'; then
        message_error "Failed to upgrade ${DEVOPS_DIRENV_PACKAGE_NAME:-direnv}"
        return 1
    fi
    message_success "Upgraded ${DEVOPS_DIRENV_PACKAGE_NAME:-direnv}"
}
