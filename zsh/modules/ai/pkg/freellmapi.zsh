# shellcheck shell=bash
# freellmapi public wrappers

function ai::freellmapi::install {
    ai::internal::freellmapi::install
}

function ai::freellmapi::upgrade {
    ai::internal::freellmapi::upgrade
}

function ai::freellmapi::status {
    ai::internal::freellmapi::status
}

function ai::freellmapi::post_install {
    ai::internal::freellmapi::post_install
}
