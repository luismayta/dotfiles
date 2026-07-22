#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::bruno::internal::load {
    if ! core::exists bru; then
      return
    fi

    # Bruno CLI is available via PATH (installed globally via bun)
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

function devops::bruno::internal::sync {
    message_info "Syncing ${DEVOPS_BRUNO_PACKAGE_NAME} configuration"
    core::ensure rsync
    rsync -avhP --no-perms "${DEVOPS_BRUNO_DATA_PATH}/" "${HOME}/.config/bruno/"
    message_success "Synced ${DEVOPS_BRUNO_PACKAGE_NAME} configuration"
}

devops::bruno::internal::load

if ! core::exists bru; then devops::bruno::internal::bru::install; fi

# core::ensure bruno