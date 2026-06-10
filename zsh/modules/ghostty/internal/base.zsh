# shellcheck shell=bash

function ghostty::internal::conf::sync {
    message_info "Syncing ghostty configuration"
    if ! core::exists rsync; then core::install rsync; fi
    rsync -avh --no-perms "${GHOSTTY_CONF_DIR}/" "${HOME}/.config/ghostty/"
    message_success "Synced ghostty configuration"
}

function ghostty::internal::ghostty::install {
    message_info "Installing ${GHOSTTY_PACKAGE_NAME}"
    if ! core::exists brew; then
        message_warning "Please install brew or use antibody bundle hadenlabs/zsh-core branch:develop"
        return
    fi
    brew install --cask ghostty
    message_success "Installed ${GHOSTTY_PACKAGE_NAME}"
}
