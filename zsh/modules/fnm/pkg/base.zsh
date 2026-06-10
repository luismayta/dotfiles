# shellcheck shell=bash
# shellcheck disable=SC2154 # FNM_PACKAGE_NAME defined in config/base.zsh

function fnm::install {
    fnm::internal::fnm::install
}

function fnm::load {
    fnm::internal::fnm::load
}

function fnm::post_install {
    message_info "Installing ${FNM_PACKAGE_NAME}"
    message_success "Installed ${FNM_PACKAGE_NAME}"
}

function fnm::upgrade {
    fnm::internal::fnm::upgrade
}

function fnm::package::all::install {
    fnm::internal::packages::install
}

function fnm::install::versions {
    fnm::internal::version::all::install
}

function fnm::install::version::global {
    fnm::internal::version::global::install
}

# Auto-invoke: load fnm and auto-install if missing
fnm::load
core::ensure curl
core::ensure unzip
if ! core::exists fnm; then fnm::install; fi
