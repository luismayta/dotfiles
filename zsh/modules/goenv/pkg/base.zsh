#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# ==============================================================================
# File: base.zsh
# Description: goenv public API wrappers
# ==============================================================================
# shellcheck shell=bash

function goenv::install {
    goenv::internal::install
}

function goenv::load {
    goenv::internal::load
}

function goenv::post_install {
    message_info "Post Install ${GOENV_PACKAGE_NAME}"
    message_success "Success Install ${GOENV_PACKAGE_NAME}"
}

function goenv::upgrade {
    goenv::internal::upgrade
}

function goenv::package::all::install {
    goenv::internal::packages::install
}

function goenv::package::install {
    goenv::internal::package::install "${@}"
}

function goenv::install::versions {
    goenv::internal::version::all::install
}

function goenv::install::version::global {
    goenv::internal::version::global::install
}
