# shellcheck shell=bash

function ai::rtk::install {
    ai::internal::rtk::install "${@}"
}

function ai::rtk::upgrade {
    ai::internal::rtk::upgrade "${@}"
}

function ai::rtk::config::sync {
    ai::internal::rtk::config::sync "${@}"
}

function ai::rtk::setup {
    ai::internal::rtk::setup "${@}"
}

function ai::rtk::post_install {
    local msg

    message_success "rtk installed — run 'rtk --version' to check the installation"

    msg="next step: run ai::rtk::setup to configure the opencode agent integration (it runs 'rtk init -g --opencode' for you)"
    message_info "${msg}"
}
