# shellcheck shell=bash

function rust::internal::rust::install {
    message_info "Installing ${RUST_PACKAGE_NAME}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    message_success "Installed ${RUST_PACKAGE_NAME}"
}

function rust::internal::rust::init {
    message_warning "not implement function rust::internal::rust::init"
}

function rust::internal::package::install {
    if ! core::exists cargo; then
        message_warning "it's necessary have cargo"
        return
    fi
    cargo install "${1}"
    message_success "Installed ${1} required cargo packages"
}

function rust::internal::rust::load {
    [ -e "${RUST_CARGO_BIN}" ] && export PATH="${RUST_CARGO_BIN}:${PATH}"
    # shellcheck source=/dev/null
    [ -e "${RUST_CARGO_ENV}" ] && source "${RUST_CARGO_ENV}"
}

function rust::internal::packages::install {
    if ! core::exists cargo; then
        message_warning "it's necessary have cargo"
        return
    fi

    message_info "Installing required cargo packages"

    for package in "${RUST_CARGO_PACKAGES[@]}"; do
        rust::internal::package::install "${package}"
    done
    message_success "Installed required cargo packages"
}

function rust::internal::version::all::install {
    message_warning "not implement function rust::internal::version::all::install"
}

function rust::internal::version::global::install {
    message_warning "not implement function rust::internal::version::global::install"
}

function rust::internal::rust::upgrade {
    message_warning "not implement function rust::internal::rust::upgrade"
}
