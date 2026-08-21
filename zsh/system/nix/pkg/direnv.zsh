#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# Public API: nix-direnv

function nix::direnv::install {
    if (( ${+functions[devops::direnv::install]} )); then
        devops::direnv::install
    else
        message_error "devops module not loaded; cannot install nix-direnv"
        return 1
    fi
}

function nix::direnv::upgrade {
    nix::direnv::internal::upgrade
}

function nix::direnv::sync {
    nix::direnv::internal::sync
}

function nix::direnv::post_install {
    message_info "Post Install ${NIX_DIRENV_PACKAGE_NAME}"
    message_success "nix-direnv installed! Run 'direnv allow' in any project with an .envrc to use it."
}
