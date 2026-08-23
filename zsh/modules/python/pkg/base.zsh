# shellcheck shell=bash

function python::upgrade {
    message_info "Upgrade ${PYTHON_PACKAGE_NAME}"
    uv self update
    message_success "Upgraded ${PYTHON_PACKAGE_NAME}"
}

function python::install {
    python::internal::uv::install
}

function python::version::all::install {
    python::internal::version::all::install
}

function python::version::global::install {
    python::internal::version::global::install
}

function python::version::global {
    python::internal::version::global::install "${@}"
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
    python::internal::uv::load
}

function python::poetry::install {
    python::internal::poetry::install
}

function python::info {
    message_info "Python: $(python --version 2>&1)"
    if core::exists uv; then
        message_info "uv: $(uv --version)"
        message_info "uv status: active"
    else
        message_info "uv status: not installed"
    fi
    if [[ "${PYTHON_UV_ENABLED}" == "true" ]]; then
        message_info "uv toggle: enabled"
    else
        message_info "uv toggle: disabled"
    fi
    message_info "Installed modules:"
    for module in "${PYTHON_MODULES[@]}"; do
        message_info "  - ${module}"
    done
}
