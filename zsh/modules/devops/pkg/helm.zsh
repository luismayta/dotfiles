#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::helm::install {
    devops::helm::internal::main::factory
}

function devops::helm::post_install {
    message_info "Post Install ${DEVOPS_HELM_PACKAGE_NAME}"
    message_success "Success Install ${DEVOPS_HELM_PACKAGE_NAME}"
}

function devops::helm::upgrade {
    message_warning "method not implement"
}
