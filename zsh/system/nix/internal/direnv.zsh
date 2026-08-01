#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# Nix-direnv internal — install via nix profile, enable direnvrc sourcing

function nix::direnv::internal::install {
    if ! nix profile list 2>/dev/null | grep -q "nix-direnv"; then
        message_info "Installing ${NIX_DIRENV_PACKAGE_NAME}"
        nix profile install "${NIX_DIRENV_NIX_PACKAGE}"
        message_success "Installed ${NIX_DIRENV_PACKAGE_NAME}"
    fi
}

function nix::direnv::internal::sync {
    message_info "Syncing ${NIX_DIRENV_PACKAGE_NAME} configuration"
    core::ensure rsync
    rsync -avzh --quiet "${NIX_DIRENV_DATA_PATH}/" "${NIX_DIRENV_CONFIG_PATH}/"
    message_success "Synced ${NIX_DIRENV_PACKAGE_NAME} configuration"
}


function nix::direnv::internal::upgrade {
    message_info "Upgrading ${NIX_DIRENV_PACKAGE_NAME}"
    nix profile upgrade nix-direnv
    message_success "Upgraded ${NIX_DIRENV_PACKAGE_NAME}"
}

function nix::direnv::internal::main::factory {
    nix::direnv::internal::install
}

nix::direnv::internal::main::factory