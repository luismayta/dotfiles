# shellcheck shell=bash

function alacritty::internal::conf::sync {
    message_info "Syncing alacritty configuration"
    if ! core::exists rsync; then core::install rsync; fi
    rsync -avh --no-perms "${ALACRITTY_DATA_PATH}/" "${HOME}/.config/alacritty/"
    message_success "Synced alacritty configuration"
}

function alacritty::internal::alacritty::install {
    message_info "Installing ${ALACRITTY_PACKAGE_NAME}"
    if ! core::exists brew; then
        message_warning "Please install brew or use antibody bundle hadenlabs/zsh-core branch:develop"
        return
    fi
    core::install alacritty
    message_success "Installed ${ALACRITTY_PACKAGE_NAME}"
}
