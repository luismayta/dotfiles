# shellcheck shell=bash
# Linux-specific devops internal functions

function devops::gcloud::internal::install {
    core::install google-cloud-cli
}

function devops::bruno::internal::bru::install {
    if ! core::exists bun; then
        message_error "bun is required to install ${DEVOPS_BRUNO_PACKAGE_NAME}"
        return 1
    fi
    message_info "Installing ${DEVOPS_BRUNO_PACKAGE_NAME} CLI"
    ${DEVOPS_BRUNO_INSTALL_CMD} "${DEVOPS_BRUNO_CLI_PACKAGE}"
    message_success "Installed ${DEVOPS_BRUNO_PACKAGE_NAME} CLI"
}

function devops::direnv::internal::install {
    if ! core::exists direnv; then
        # Ensure nix is available in PATH
        if ! command -v nix &>/dev/null; then
            if [[ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]]; then
                source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
            elif [[ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]]; then
                source "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
            fi
            if ! command -v nix &>/dev/null; then
                message_error "nix is not available in PATH. Install nix: https://nixos.org/download"
                return 1
            fi
        fi
        message_info "Installing direnv"
        nix profile install "nixpkgs#direnv"
    fi
    if ! nix profile list 2>/dev/null | grep -q "nix-direnv"; then
        message_info "Installing nix-direnv plugin"
        nix profile install "${DEVOPS_DIRENV_NIX_DIRENV_PACKAGE}"
        message_success "Installed nix-direnv"
    fi
}

function devops::direnv::internal::upgrade {
    message_info "Upgrading ${DEVOPS_DIRENV_PACKAGE_NAME}"
    nix profile upgrade nix-direnv
    message_success "Upgraded ${DEVOPS_DIRENV_PACKAGE_NAME}"
}
