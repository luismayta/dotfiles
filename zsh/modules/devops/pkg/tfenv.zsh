#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::tfenv::install {
    devops::tfenv::internal::tfenv::install
}

function devops::tfenv::load {
    devops::tfenv::internal::tfenv::load
}

function devops::tfenv::post_install {
    message_info "Post Install ${DEVOPS_TFENV_PACKAGE_NAME}"
    message_success "Success Install ${DEVOPS_TFENV_PACKAGE_NAME}"
}

function devops::tfenv::upgrade {
    devops::tfenv::internal::tfenv::upgrade
}

function devops::tfenv::install::versions {
    devops::tfenv::internal::version::all::install
}

function devops::tfenv::install::version::global {
    devops::tfenv::internal::version::global::install
}
