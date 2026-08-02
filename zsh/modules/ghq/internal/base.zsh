# shellcheck shell=bash
# shellcheck disable=SC2154 # ZSH_GHQ_PACKAGE_NAME defined in config/base.zsh

function ghq::internal::install {
    if core::exists "${ZSH_GHQ_PACKAGE_NAME}"; then
        return 0
    fi
    message_info "Installing ${ZSH_GHQ_PACKAGE_NAME}"
    if core::install "${ZSH_GHQ_PACKAGE_NAME}"; then
        message_success "Installed ${ZSH_GHQ_PACKAGE_NAME}"
    else
        message_error "Failed to install ${ZSH_GHQ_PACKAGE_NAME}"
        return 1
    fi
}

function ghq::internal::cookiecutter::install {
    if ! core::exists pip; then
        message_warning "Please install pip for continue"
        return
    fi
    message_info "Installing cookiecutter for ${ZSH_GHQ_PACKAGE_NAME}"
    python -m pip install --user cookiecutter
    message_success "Installed cookiecutter for ${ZSH_GHQ_PACKAGE_NAME}"
}
