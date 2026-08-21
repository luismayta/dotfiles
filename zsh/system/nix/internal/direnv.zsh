#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# Nix-direnv internal — sync only. Installation of nix-direnv is owned by the
# devops module (see zsh/modules/devops), not by nix.

function nix::direnv::internal::sync {
    message_info "Syncing ${NIX_DIRENV_PACKAGE_NAME} configuration"
    core::ensure rsync
    rsync -avzh --quiet "${NIX_DIRENV_DATA_PATH}/" "${NIX_DIRENV_CONFIG_PATH}/"
    message_success "Synced ${NIX_DIRENV_PACKAGE_NAME} configuration"
}