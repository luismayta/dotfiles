# shellcheck shell=bash
# Linux-specific Nix internals — nix.conf sync
# Uses NIX_DATA_PATH/nix/ via nix::internal::config::sync (internal/base.zsh)
# install/upgrade keep the original behavior (no extra-experimental-features)

function nix::direnv::internal::install {
    if ! nix profile list 2>/dev/null | grep -q "nix-direnv"; then
        message_info "Installing ${NIX_DIRENV_PACKAGE_NAME}"
        nix profile install "${NIX_DIRENV_NIX_PACKAGE}"
        message_success "Installed ${NIX_DIRENV_PACKAGE_NAME}"
    fi
}

function nix::direnv::internal::upgrade {
    message_info "Upgrading ${NIX_DIRENV_PACKAGE_NAME}"
    nix profile upgrade nix-direnv
    message_success "Upgraded ${NIX_DIRENV_PACKAGE_NAME}"
}