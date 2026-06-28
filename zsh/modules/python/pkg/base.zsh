# shellcheck shell=bash
# shellcheck disable=SC2154 # PYTHON_PACKAGE_NAME defined in config/base.zsh

function python::upgrade {
    message_info "Upgrade ${PYTHON_PACKAGE_NAME}"
    cd "${PYTHON_ROOT}" || exit && git pull && cd - || return
    message_success "Upgraded ${PYTHON_PACKAGE_NAME}"
}

function python::install {
    python::internal::pyenv::install
}

function python::version::all::install {
    python::internal::version::all::install
}

function python::version::global::install {
    python::internal::version::global::install
}

function python::modules::install {
    python::internal::modules::install
}

function python::module::install {
    python::internal::module::install "${@}"
}

function python::post_install {
    python::version::global::install
    python::modules::install
}

function python::load {
    python::internal::pyenv::load
}

function python::poetry::install {
    python::internal::poetry::install
}
