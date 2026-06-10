#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::internal::packages::install {
    message_info "Installing required devops packages"
    for package in "${DEVOPS_PACKAGES[@]}"; do
        core::install "${package}"
    done
    message_success "Installed required devops packages"
}
