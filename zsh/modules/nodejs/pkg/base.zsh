# shellcheck shell=bash
# shellcheck disable=SC2154 # NODEJS_TOOL_NAME defined in config/base.zsh

function nodejs::install {
    nodejs::internal::fnm::install
}

function nodejs::load {
    nodejs::internal::fnm::load
}

function nodejs::post_install {
    message_info "Installing ${NODEJS_TOOL_NAME}"
    message_success "Installed ${NODEJS_TOOL_NAME}"
}

function nodejs::upgrade {
    nodejs::internal::fnm::upgrade
}

function nodejs::package::all::install {
    nodejs::internal::packages::install
}

function nodejs::install::versions {
    nodejs::internal::version::all::install
}

function nodejs::install::version::global {
    nodejs::internal::version::global::install
}

# Auto-invoke: load nodejs and auto-install if missing
nodejs::load
core::ensure curl
core::ensure unzip
if ! core::exists fnm; then nodejs::install; fi

nodejs::internal::bun::install

nodejs::internal::bunx::load
