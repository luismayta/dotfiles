#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# GitHub CLI public functions

function github::install {
    github::internal::main::factory
}

function github::upgrade {
    core::upgrade gh
}

function github::post_install {
    message_info "Post Install ${ZSH_GITHUB_PACKAGE_NAME}"
    github::sync
    message_success "Success Install ${ZSH_GITHUB_PACKAGE_NAME}"
}

function github::sync {
    message_info "${ZSH_GITHUB_PACKAGE_NAME} sync conf for ${ZSH_GITHUB_PACKAGE_NAME}"
    core::ensure rsync
    rsync -avzh --progress "${ZSH_GITHUB_DATA_PATH}/" "${ZSH_GITHUB_DASH_CONF_PATH}/"
    message_success "sync for ${ZSH_GITHUB_PACKAGE_NAME}"
}

# Aliases
alias ghd="gh dash"

function editghdash {
    if [ -z "${EDITOR}" ]; then
        message_warning "EDITOR is not set. Please set EDITOR to edit gh-dash config."
        return 1
    fi
    "${EDITOR}" "${ZSH_GITHUB_DASH_CONF_PATH}/config.yaml"
}
