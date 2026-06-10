#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function pazi::internal::pazi::install {
    if ! core::exists cargo > /dev/null; then
        message_warning "${PAZI_MESSAGE_CARGO}"
        return
    fi
    message_info "Installing ${PAZI_PACKAGE_NAME}"
    cargo install "${PAZI_PACKAGE_NAME}"
    message_success "Installed ${PAZI_PACKAGE_NAME}"
}

function pazi::internal::pazi::load {
    if core::exists pazi; then
        eval "$(pazi init zsh)"
    fi
}
