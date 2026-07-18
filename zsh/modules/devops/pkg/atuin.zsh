#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::atuin::install {
    devops::atuin::internal::main::factory
}

function devops::atuin::upgrade {
    devops::atuin::internal::upgrade
}

function devops::atuin::post_install {
    message_info "Post Install ${DEVOPS_ATUIN_PACKAGE_NAME}"
    message_success "Atuin installed! Run 'atuin login' to enable sync, or 'atuin import zsh' to import existing history."
}
