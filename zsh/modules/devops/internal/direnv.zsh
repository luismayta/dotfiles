#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::direnv::internal::load {
    if core::exists direnv; then
        eval "$(direnv hook zsh)"
    fi
}

function devops::direnv::internal::install {
    if ! nix profile list 2>/dev/null | grep -q "nix-direnv"; then
        message_info "Installing ${DEVOPS_DIRENV_PACKAGE_NAME} with nix-direnv"
        nix profile install "${DEVOPS_DIRENV_NIX_DIRENV_PACKAGE}"
        message_success "Installed ${DEVOPS_DIRENV_PACKAGE_NAME}"
    fi
}

function devops::direnv::internal::upgrade {
    message_info "Upgrading ${DEVOPS_DIRENV_PACKAGE_NAME}"
    nix profile upgrade nix-direnv
    message_success "Upgraded ${DEVOPS_DIRENV_PACKAGE_NAME}"
}

function devops::direnv::internal::main::factory {
    if ! core::exists direnv; then
        devops::direnv::internal::install
    fi
}

function devops::direnv::internal::sync {
    message_info "Syncing ${DEVOPS_DIRENV_PACKAGE_NAME} configuration"
    core::ensure rsync
    rsync -avzh --quiet "${DEVOPS_DIRENV_DATA_PATH}/" "${HOME}/.config/direnv/"
    message_success "Synced ${DEVOPS_DIRENV_PACKAGE_NAME} configuration"
}

devops::direnv::internal::load
devops::direnv::internal::main::factory
