#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::worktrunk::internal::load {
    if ! core::exists wt; then
      return
    fi

    # Worktrunk CLI is available via PATH
}

function devops::worktrunk::internal::wt::install {
    message_info "Installing ${DEVOPS_WORKTRUNK_PACKAGE_NAME}"
    core::install "${DEVOPS_WORKTRUNK_PACKAGE_NAME}"
    message_success "Installed ${DEVOPS_WORKTRUNK_PACKAGE_NAME}"
}

function devops::worktrunk::internal::upgrade {
    message_info "Not Implemented ${DEVOPS_WORKTRUNK_PACKAGE_NAME}"
}

devops::worktrunk::internal::load

if ! core::exists wt; then devops::worktrunk::internal::wt::install; fi