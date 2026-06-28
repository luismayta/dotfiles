# shellcheck shell=bash

function rust::internal::rust::install {
    message_info "Installing ${RUST_PACKAGE_NAME}"
    curl --proto '=https' --tlsv1.2 -sSf "${RUST_INSTALL_URL_RUSTUP}" | sh
    message_success "Installed ${RUST_PACKAGE_NAME}"
}

function rust::internal::rust::init {
    message_warning "not implement function rust::internal::rust::init"
}

function rust::internal::rust::load {
    [ -e "${RUST_CARGO_BIN}" ] && export PATH="${RUST_CARGO_BIN}:${PATH}"
    # shellcheck source=/dev/null
    [ -e "${RUST_CARGO_ENV}" ] && source "${RUST_CARGO_ENV}"
}

# ── Handlers per type ─────────────────────────────────────────────────────────
function rust::internal::package::install::simple {
    [[ ${#@} -eq 0 ]] && return
    cargo install "$@"
}

function rust::internal::package::install::locked {
    [[ ${#@} -eq 0 ]] && return
    cargo install --locked "$@"
}

function rust::internal::package::install::features {
    local pkg
    for pkg in "$@"; do
        cargo install "${pkg}"
    done
}

function rust::internal::package::install::git {
    local pkg
    for pkg in "$@"; do
        cargo install "${pkg}"
    done
}

function rust::internal::package::install::system {
    [[ ${#@} -eq 0 ]] && return
    local pkg
    for pkg in "$@"; do
        core::ensure "${pkg}"
    done
}

# ── Legacy single-package install (preserved for backward compat) ────────────
function rust::internal::package::install {
    if ! core::exists cargo; then
        message_warning "it's necessary have cargo"
        return
    fi
    cargo install "${1}"
    message_success "Installed ${1} required cargo packages"
}

# ── Orchestrator ───────────────────────────────────────────────────────────────
function rust::internal::packages::install {
    if ! core::exists cargo; then
        message_warning "it's necessary have cargo"
        return
    fi

    message_info "Installing required cargo packages"

    rust::internal::package::install::simple "${RUST_CARGO_PACKAGES_SIMPLE[@]}"
    rust::internal::package::install::locked "${RUST_CARGO_PACKAGES_LOCKED[@]}"
    rust::internal::package::install::features "${RUST_CARGO_PACKAGES_FEATURES[@]}"
    rust::internal::package::install::git "${RUST_CARGO_PACKAGES_GIT[@]}"
    rust::internal::package::install::system "${RUST_SYSTEM_PACKAGES[@]}"

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
