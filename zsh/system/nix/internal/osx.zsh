# shellcheck shell=bash
# macOS-specific Nix internals — install/upgrade with nix-command + flakes
# (nix-command is disabled by default on macOS; these flags enable it)

function nix::direnv::internal::install {
    if ! nix profile list --extra-experimental-features 'nix-command flakes' 2>/dev/null | grep -q "nix-direnv"; then
        message_info "Installing ${NIX_DIRENV_PACKAGE_NAME}"
        if ! nix profile add "${NIX_DIRENV_NIX_PACKAGE}" --extra-experimental-features 'nix-command flakes'; then
            message_error "Failed to install ${NIX_DIRENV_PACKAGE_NAME}"
            return 1
        fi
        message_success "Installed ${NIX_DIRENV_PACKAGE_NAME}"
    fi
}

function nix::direnv::internal::upgrade {
    message_info "Upgrading ${NIX_DIRENV_PACKAGE_NAME}"
    if ! nix profile upgrade nix-direnv --extra-experimental-features 'nix-command flakes'; then
        message_error "Failed to upgrade ${NIX_DIRENV_PACKAGE_NAME}"
        return 1
    fi
    message_success "Upgraded ${NIX_DIRENV_PACKAGE_NAME}"
}
