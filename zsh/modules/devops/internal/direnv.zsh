#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::direnv::internal::load {
    if core::exists direnv; then
        eval "$(direnv hook zsh)"
    fi
}

function devops::direnv::internal::is_managed {
    if nix profile list 2>/dev/null | grep -q "nix-direnv"; then
        return 0
    fi
    if grep -q "nix-direnv" "${HOME}/.config/direnv/direnvrc" 2>/dev/null; then
        return 0
    fi
    if [[ "${OSTYPE}" == darwin* ]] && command -v darwin-rebuild &>/dev/null; then
        if [[ -f "/etc/profiles/per-user/${USER}/share/nix-direnv/direnvrc" ]] || [[ -f "/run/current-system/sw/share/nix-direnv/direnvrc" ]]; then
            return 0
        fi
    fi
    return 1
}

function devops::direnv::internal::main::factory {
    if ! core::exists direnv || ! devops::direnv::internal::is_managed; then
        devops::direnv::internal::install
    fi
}

function devops::direnv::internal::sync {
    message_info "Syncing ${DEVOPS_DIRENV_PACKAGE_NAME} configuration"
    core::ensure rsync
    rsync -avzh --quiet "${DEVOPS_DIRENV_DATA_PATH}/" "${HOME}/.config/direnv/"
    message_success "Synced ${DEVOPS_DIRENV_PACKAGE_NAME} configuration"
}

devops::direnv::internal::load
devops::direnv::internal::main::factory
