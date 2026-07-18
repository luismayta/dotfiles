#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::atuin::internal::install {
    message_info "Installing ${DEVOPS_ATUIN_PACKAGE_NAME}"
    curl --proto '=https' --tlsv1.2 -LsSf "${DEVOPS_ATUIN_INSTALL_URL}" | sh
    message_success "Installed ${DEVOPS_ATUIN_PACKAGE_NAME}"
}

function devops::atuin::internal::upgrade {
    message_info "Upgrading ${DEVOPS_ATUIN_PACKAGE_NAME}"
    curl --proto '=https' --tlsv1.2 -LsSf "${DEVOPS_ATUIN_INSTALL_URL}" | sh
    message_success "Upgraded ${DEVOPS_ATUIN_PACKAGE_NAME}"
}

function devops::atuin::internal::main::factory {
    if ! core::exists atuin; then
        devops::atuin::internal::install
    fi

    # Shell integration — eval atuin init zsh with configurable flags
    eval "$(atuin init zsh ${DEVOPS_ATUIN_INIT_FLAGS[*]})"
}

devops::atuin::internal::main::factory
