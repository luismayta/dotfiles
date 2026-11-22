#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::mise::internal::load {
    if ! core::exists mise; then
        return
    fi

    # Shell integration — eval mise activate zsh with configurable flags
    eval "$(mise activate zsh ${DEVOPS_MISE_INIT_FLAGS[@]+"${DEVOPS_MISE_INIT_FLAGS[@]}"})"
}

function devops::mise::internal::install {
    if core::exists mise; then
        message_info "${DEVOPS_MISE_PACKAGE_NAME} already installed"
        return 0
    fi

    if [[ "${ZSH_NIX_DARWIN_AVAILABLE:-false}" == "true" ]]; then
        message_warning "nix-darwin manages ${DEVOPS_MISE_PACKAGE_NAME}; skipping profile install"
        return 0
    fi

    if command -v nix >/dev/null 2>&1; then
        if ! core::nix::package::install "${DEVOPS_MISE_NIX_PACKAGE}"; then
            message_error "Failed to install ${DEVOPS_MISE_PACKAGE_NAME}"
            return 1
        fi
    else
        message_info "nix not available; falling back to native package manager"
        if ! core::install "${DEVOPS_MISE_PACKAGE_NAME}"; then
            message_error "Failed to install ${DEVOPS_MISE_PACKAGE_NAME}"
            return 1
        fi
        message_success "Installed ${DEVOPS_MISE_PACKAGE_NAME}"
    fi
}

function devops::mise::internal::upgrade {
    core::nix::package::upgrade "${DEVOPS_MISE_NIX_PACKAGE##*#}"
}

function devops::mise::internal::main::factory {
    if ! core::exists mise; then
        devops::mise::internal::install
    fi
}

devops::mise::internal::load

devops::mise::internal::main::factory
