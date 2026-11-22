#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::mise::install {
    devops::mise::internal::install
}

function devops::mise::upgrade {
    devops::mise::internal::upgrade
}

function devops::mise::post_install {
    message_info "Post Install ${DEVOPS_MISE_PACKAGE_NAME}"
    message_info "Run 'mise use node@latest' to pin a tool version in this project"
    message_success "Mise installed! Run 'mise doctor' to check your environment configuration."
}
