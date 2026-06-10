# shellcheck shell=bash
# shellcheck disable=SC2154 # PYENV_PACKAGE_NAME defined in config/base.zsh

function pyenv::upgrade {
    message_info "Upgrade ${PYENV_PACKAGE_NAME}"
    cd "${PYENV_ROOT}" || exit && git pull && cd - || return
    message_success "Upgraded ${PYENV_PACKAGE_NAME}"
}

function pyenv::install {
    pyenv::internal::pyenv::install
}

function pyenv::version::all::install {
    pyenv::internal::version::all::install
}

function pyenv::version::global::install {
    pyenv::internal::version::global::install
}

function pyenv::modules::install {
    pyenv::internal::modules::install
}

function pyenv::module::install {
    pyenv::internal::module::install "${@}"
}

function pyenv::post_install {
    pyenv::version::global::install
    pyenv::modules::install
}

function pyenv::load {
    pyenv::internal::pyenv::load
}

function pyenv::poetry::install {
    pyenv::internal::poetry::install
}

