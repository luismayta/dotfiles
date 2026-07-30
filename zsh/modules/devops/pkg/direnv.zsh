#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::direnv::install {
    devops::direnv::internal::main::factory
}

function devops::direnv::upgrade {
    devops::direnv::internal::upgrade
}

function devops::direnv::sync {
    devops::direnv::internal::sync
}

function devops::direnv::post_install {
    message_info "Post Install ${DEVOPS_DIRENV_PACKAGE_NAME}"
    message_success "Direnv installed! Run 'direnv allow' in directories with .envrc files."
}
