# shellcheck shell=bash
# shellcheck disable=SC2154 # SCMBREEZE_PACKAGE_NAME defined in config/base.zsh

function scmbreeze::install {
    scmbreeze::internal::install
}

function scmbreeze::load {
    scmbreeze::internal::load
}

function scmbreeze::post_install {
    message_info "Post Install ${SCMBREEZE_PACKAGE_NAME}"
    message_success "Success Install ${SCMBREEZE_PACKAGE_NAME}"
}

# Auto-invoke: load scmbreeze
scmbreeze::load
