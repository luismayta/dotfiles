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

function github::internal::install_dash {
    message_info "Installing gh-dash extension"
    gh extension install dlvhdr/gh-dash
    message_success "Installed gh-dash extension"
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
    if ! gh extension list 2>/dev/null | grep -q dlvhdr/gh-dash; then
        github::internal::install_dash
    fi
    github::internal::load
fi
