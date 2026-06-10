# shellcheck shell=bash
# shellcheck disable=SC2154 # GHQ_PACKAGE_NAME defined in config/base.zsh

function ghq::internal::ghq::install {
    message_info "Installing ${GHQ_PACKAGE_NAME}"
    if core::exists brew; then
        brew install "${GHQ_PACKAGE_NAME}"
    elif core::exists paru; then
        paru -S --noconfirm "${GHQ_PACKAGE_NAME}"
    else
        message_error "No package manager found to install ${GHQ_PACKAGE_NAME}"
        return 1
    fi
    message_success "Installed ${GHQ_PACKAGE_NAME}"
}

function ghq::internal::cookiecutter::install {
    if ! core::exists pip; then
        message_warning "Please install pip for continue"
        return
    fi
    message_info "Installing cookiecutter for ${GHQ_PACKAGE_NAME}"
    python -m pip install --user cookiecutter
    message_success "Installed cookiecutter for ${GHQ_PACKAGE_NAME}"
}
