# shellcheck shell=bash
# shellcheck disable=SC2154 # PYENV_PACKAGE_NAME defined in config/base.zsh

function pyenv::internal::pyenv::install {
    message_info "Installing ${PYENV_PACKAGE_NAME}"
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    message_success "Installed ${PYENV_PACKAGE_NAME}"
}

function pyenv::internal::pyenv::load {
    [ -e "${PYENV_ROOT_BIN}" ] && export PATH="${PYENV_ROOT_BIN}:${PATH}"

    # Lazy load pyenv
    if type -p pyenv > /dev/null; then
        export PATH="${PYENV_ROOT}/shims:${PATH}"
    fi
}

function pyenv::internal::version::all::install {
    if ! core::exists pyenv; then
        message_warning "not found pyenv"
        return
    fi

    for version in "${PYENV_VERSIONS[@]}"; do
        message_info "Install version of python ${version}"
        pyenv install "${version}"
        message_success "Installed version of python ${version}"
    done
    pyenv global "${PYENV_VERSION_GLOBAL}"
    message_success "Installed versions of Python"

}

function pyenv::internal::version::global::install {
    if ! core::exists pyenv; then
        message_warning "not found pyenv"
        return
    fi
    message_info "Installing version global of python ${PYENV_VERSION_GLOBAL}"
    pyenv install "${PYENV_VERSION_GLOBAL}"
    pyenv global "${PYENV_VERSION_GLOBAL}"
    message_success "Installed version global of python ${PYENV_VERSION_GLOBAL}"
}

function pyenv::internal::module::install {
    if ! core::exists python; then
        message_warning "it's necessary have python"
        return
    fi

    python -m pip install --user --upgrade "${@}"
}

function pyenv::internal::modules::install {
    if ! core::exists python; then
        message_warning "it's necessary have python"
        return
    fi

    message_info "Installing required python modules"
    python -m pip install --user --upgrade "${PYENV_MODULES[@]}"
    message_success "Installed required python modules"
}

function pyenv::internal::poetry::install {
    if ! core::exists python; then
        message_warning "it's necessary have python"
        return
    fi

    message_info "Installing poetry"
    pipx install "poetry"
    message_success "Installed poetry"

    message_info "Installing plugins poetry"
    # https://github.com/MousaZeidBaker/poetry-plugin-up
    poetry self add poetry-plugin-up poetry-plugin-sort poetry-bumpversion
    message_success "Installed plugins poetry"
}
