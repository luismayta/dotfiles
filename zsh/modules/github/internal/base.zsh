#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# GitHub CLI internal functions

function github::internal::main::factory {
    core::ensure gh
}

function github::internal::install_completions {
    message_info "Installing ${ZSH_GITHUB_PACKAGE_NAME} completions"
    gh completion -s zsh > "${ZSH_GITHUB_DATA_PATH}/completions.zsh"
    message_success "Installed ${ZSH_GITHUB_PACKAGE_NAME} completions"
}

function github::internal::extension::install {
    local ext="${1}"
    if ! gh extension list 2>/dev/null | grep -q "${ext}"; then
        message_info "Installing gh extension ${ext}"
        gh extension install "${ext}"
        message_success "Installed gh extension ${ext}"
    fi
}

function github::internal::extensions::install {
    if ! core::exists gh; then return; fi
    message_info "Installing required gh extensions"
    for ext in "${ZSH_GITHUB_EXTENSIONS[@]}"; do
        github::internal::extension::install "${ext}"
    done
    message_success "Installed required gh extensions"
}

function github::internal::load {
    if [[ -f "${ZSH_GITHUB_DATA_PATH}/completions.zsh" ]]; then
        # shellcheck source=/dev/null
        source "${ZSH_GITHUB_DATA_PATH}/completions.zsh"
    fi
}

github::internal::main::factory

if core::exists gh; then
    github::internal::install_completions
    github::internal::extensions::install
    github::internal::load
fi
