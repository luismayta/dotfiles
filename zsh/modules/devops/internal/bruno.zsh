#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::bruno::internal::load {
    if ! core::exists bru; then
      return
    fi

    # Bruno CLI is available via PATH (installed globally via bun)
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