# shellcheck shell=bash

function python::internal::uv::install {
    if core::exists uv; then
        return 0
    fi
    message_info "Installing ${PYTHON_PACKAGE_NAME}..."
    if curl -fsSL "${PYTHON_INSTALL_URL}" | sh; then
        message_success "${PYTHON_PACKAGE_NAME} installed successfully."
    else
        message_error "Failed to install ${PYTHON_PACKAGE_NAME}."
        return 1
    fi
}

function python::internal::uv::load {
    if [[ "${PYTHON_UV_ENABLED}" != "true" ]]; then
        return
    fi
    if ! core::exists uv; then
        python::internal::uv::install
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
    if ! core::exists uv; then
        message_warning "not found uv"
        return
    fi

    for version in "${PYTHON_VERSIONS[@]}"; do
        message_info "Install version of python ${version}"
        uv python install "${version}"
        message_success "Installed version of python ${version}"
    done
    uv python install "${PYTHON_VERSION_GLOBAL}" --default
    message_success "Installed versions of Python"

}

function python::internal::version::global::install {
    if ! core::exists uv; then
        message_warning "not found uv"
        return
    fi
    message_info "Installing version global of python ${PYTHON_VERSION_GLOBAL}"
    uv python install "${PYTHON_VERSION_GLOBAL}" --default
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
