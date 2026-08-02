# shellcheck shell=bash
# shellcheck disable=SC2154 # ZSH_GHQ_PACKAGE_NAME defined in config/base.zsh

function ghq::setup {
    message_info "Setting up ${ZSH_GHQ_PACKAGE_NAME}..."
    if ! core::exists "${ZSH_GHQ_PACKAGE_NAME}"; then
        ghq::install
    else
        message_info "${ZSH_GHQ_PACKAGE_NAME} is already installed."
    fi
    ghq::post_install
    message_success "${ZSH_GHQ_PACKAGE_NAME} setup complete."
}
