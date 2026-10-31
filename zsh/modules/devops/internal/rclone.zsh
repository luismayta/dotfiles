#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::rclone::internal::load {
    if ! core::exists rclone; then
        return
    fi

    # rclone is available on PATH
}

function devops::rclone::internal::install {
    if core::exists rclone; then
        message_info "${DEVOPS_RCLONE_PACKAGE_NAME} already installed"
        return 0
    fi

    message_info "Installing ${DEVOPS_RCLONE_PACKAGE_NAME}"
    if ! core::install "${DEVOPS_RCLONE_PACKAGE_NAME}"; then
        message_error "Failed to install ${DEVOPS_RCLONE_PACKAGE_NAME}"
        return 1
    fi
    message_success "Installed ${DEVOPS_RCLONE_PACKAGE_NAME}"
}

function devops::rclone::internal::upgrade {
    if ! core::exists rclone; then
        devops::rclone::internal::install
        return
    fi

    message_info "Upgrading ${DEVOPS_RCLONE_PACKAGE_NAME}"
    if ! core::install "${DEVOPS_RCLONE_PACKAGE_NAME}"; then
        message_error "Failed to upgrade ${DEVOPS_RCLONE_PACKAGE_NAME}"
        return 1
    fi
    message_success "Upgraded ${DEVOPS_RCLONE_PACKAGE_NAME}"
}

function devops::rclone::internal::main::factory {
    core::ensure rclone
}

devops::rclone::internal::load
devops::rclone::internal::main::factory
