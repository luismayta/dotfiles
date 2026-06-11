#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::k9s::sync {
    message_info "k9s sync conf for ${DEVOPS_K9S_PACKAGE_NAME}"
    rsync -avzh --progress "${DEVOPS_PATH}/data/k9s/" "${DEVOPS_K9S_CONF_DIR}/"
    message_success "sync for ${DEVOPS_K9S_PACKAGE_NAME}"
}

function devops::k9s::install {
    devops::k9s::internal::main::factory
}

function devops::k9s::upgrade {
    message_warning "method not implement"
}

function devops::k9s::post_install {
    message_info "Post Install ${DEVOPS_K9S_PACKAGE_NAME}"
    devops::k9s::sync
    message_success "Success Install ${DEVOPS_K9S_PACKAGE_NAME}"
}

# editk9s edit settings for k9s
function editk9s {
    if [ -z "${EDITOR}" ]; then
        message_warning "it's necessary the var EDITOR"
        return
    fi
    "${EDITOR}" "${DEVOPS_K9S_FILE_SETTINGS}"
}
