# shellcheck shell=bash

function rvm::install {
    rvm::internal::rvm::install
}

function rvm::load {
    rvm::internal::rvm::load
}

function rvm::post_install {
    message_info "Post Install ${RVM_PACKAGE_NAME}"
    message_success "Success Install ${RVM_PACKAGE_NAME}"
}

function rvm::upgrade {
    rvm::internal::rvm::upgrade
}

function rvm::package::all::install {
    rvm::internal::packages::install
}

function rvm::install::versions {
    rvm::internal::version::all::install
}

function rvm::install::version::global {
    rvm::internal::version::global::install
}
