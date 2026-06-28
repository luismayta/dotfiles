# shellcheck shell=bash
# shellcheck disable=SC2154 # PYTHON_PACKAGE_NAME defined in config/base.zsh

function python::internal::pyenv::install {
    message_info "Installing ${PYTHON_PACKAGE_NAME}"
    git clone "${PYTHON_INSTALL_URL}" ~/.pyenv
    message_success "Installed ${PYTHON_PACKAGE_NAME}"
}

function python::internal::pyenv::load {
    [ -e "${PYTHON_ROOT_BIN}" ] && export PATH="${PYTHON_ROOT_BIN}:${PATH}"

    # Lazy load pyenv
    if type -p pyenv > /dev/null; then
        export PATH="${PYTHON_ROOT}/shims:${PATH}"
    fi
}

function python::internal::uv::load {
    if [[ "${PYTHON_UV_ENABLED}" != "true" ]]; then
        return
    fi
    if ! core::exists uv; then
        core::ensure uv
    fi
}

function python::internal::uv::completions {
    if [[ "${PYTHON_UV_ENABLED}" != "true" ]]; then
        return
    fi
    if type -p uv > /dev/null; then
        # shellcheck disable=SC1090
        source <(uv generate-shell-completion zsh)
    fi
}

function python::internal::version::all::install {
    if ! core::exists pyenv; then
        message_warning "not found pyenv"
        return
    fi

    for version in "${PYTHON_VERSIONS[@]}"; do
        message_info "Install version of python ${version}"
        pyenv install "${version}"
        message_success "Installed version of python ${version}"
    done
    pyenv global "${PYTHON_VERSION_GLOBAL}"
    message_success "Installed versions of Python"

}

function python::internal::version::global::install {
    if ! core::exists pyenv; then
        message_warning "not found pyenv"
        return
    fi
    message_info "Installing version global of python ${PYTHON_VERSION_GLOBAL}"
    pyenv install "${PYTHON_VERSION_GLOBAL}"
    pyenv global "${PYTHON_VERSION_GLOBAL}"
    message_success "Installed version global of python ${PYTHON_VERSION_GLOBAL}"
}

function python::internal::module::install {
    if ! core::exists python; then
        message_warning "it's necessary have python"
        return
    fi

    python -m pip install --user --upgrade "${@}"
}

function python::internal::modules::install {
    if ! core::exists python; then
        message_warning "it's necessary have python"
        return
    fi

    message_info "Installing required python modules"
    python -m pip install --user --upgrade "${PYTHON_MODULES[@]}"
    message_success "Installed required python modules"
}

function python::internal::poetry::install {
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
