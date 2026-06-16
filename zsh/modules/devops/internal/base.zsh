#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::internal::packages::install {
    message_info "Installing required devops packages"
    for package in "${DEVOPS_PACKAGES[@]}"; do
        core::install "${package}"
    done
    message_success "Installed required devops packages"
}

function devops::internal::go::packages::install {
    message_info "Installing required devops packages"
    for package in "${DEVOPS_GO_PACKAGES[@]}"; do
        goenv::package::install "${package}"
    done
    message_success "Installed required devops packages"
}

function devops::internal::go::direnv::load {
    if core::exists direnv; then
        eval "$(direnv hook zsh)"
    fi
}