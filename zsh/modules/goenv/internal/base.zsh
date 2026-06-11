#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# ==============================================================================
# File: base.zsh
# Description: goenv internal implementation functions
# ==============================================================================
# shellcheck shell=bash

function goenv::internal::install {
    message_info "Installing ${GOENV_PACKAGE_NAME}"
    curl -sLk "${GOBREW_DOWNLOAD_URL}" | sh
    message_success "Installed ${GOENV_PACKAGE_NAME}"
}

function goenv::internal::load {
    unset GOPATH
    if [[ -e "${GOBREW_ROOT_BIN}" ]]; then
        export PATH="${GOBREW_CURRENT_BIN}:${GOBREW_ROOT_BIN}:${PATH}"
    fi
    export GOPATH="${HOME}/.gobrew/current/go"
}

function goenv::internal::package::install {
    if ! core::exists go; then
        message_warning "it's necessary have go"
        return
    fi
    GO111MODULE=on go install "${1}"
    message_success "Installed ${1} required Go packages"
}

function goenv::internal::packages::install {
    if ! core::exists go; then
        message_warning "it's necessary have go"
        return
    fi
    message_info "Installing required go packages"
    curl -sSfL "${GOENV_INSTALL_URL_LINT}" | sh -s -- -b "$(go env GOPATH)"/bin v1.41.0
    local package
    for package in "${GOENV_INSTALL_PACKAGES[@]}"; do
        goenv::internal::package::install "${package}"
    done
    message_success "Installed required Go packages"
}

function goenv::internal::version::all::install {
    if ! core::exists gobrew; then
        message_warning "not found gobrew"
        return
    fi
    local version
    for version in "${GOENV_VERSIONS[@]}"; do
        message_info "Install version of go ${version}"
        gobrew install "${version}"
        message_success "Installed version of go ${version}"
    done
    gobrew use "${GOENV_VERSION_GLOBAL}"
    message_success "Installed versions of Go"
}

function goenv::internal::version::global::install {
    if ! core::exists gobrew; then
        message_warning "not found gobrew"
        return
    fi
    message_info "Installing version global of go ${GOENV_VERSION_GLOBAL}"
    gobrew install "${GOENV_VERSION_GLOBAL}"
    gobrew use "${GOENV_VERSION_GLOBAL}"
    message_success "Installed version global of go ${GOENV_VERSION_GLOBAL}"
}

function goenv::internal::upgrade {
    message_info "Upgrade for ${GOENV_PACKAGE_NAME}"
    curl -sLk "${GOBREW_INSTALL_URL}" | sh -
    message_success "Upgraded ${GOENV_PACKAGE_NAME}"
}
