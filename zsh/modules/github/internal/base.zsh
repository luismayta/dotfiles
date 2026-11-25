#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# GitHub CLI internal functions

function github::internal::main::factory {
    core::ensure gh
}

function github::internal::install_completions {
    local completions="${ZSH_GITHUB_CONF_PATH}/completions.zsh"
    local tmpfile="${completions}.tmp.$$"
    local script

    # Generate once: skip quietly if the file exists or gh is unavailable.
    [[ -f "${completions}" ]] && return 0
    command -v gh >/dev/null 2>&1 || return 0

    script="$(gh completion -s zsh 2>/dev/null)" || return 0
    [[ -n "${script}" ]] || return 0
    mkdir -p "${ZSH_GITHUB_CONF_PATH}" 2>/dev/null || return 0

    # Write to a temp file in the same directory, verify it is non-empty,
    # then atomically move it into place: a partial/interrupted write must
    # never reach the final path, or the [[ -f ]] guard above would treat
    # it as valid forever.
    if ! { print -r -- "${script}" 2>/dev/null > "${tmpfile}" &&
             [[ -s "${tmpfile}" ]] &&
             mv "${tmpfile}" "${completions}" 2>/dev/null
    }; then
        rm -f "${tmpfile}"
        return 0
    fi

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
    if [[ -f "${ZSH_GITHUB_CONF_PATH}/completions.zsh" ]]; then
        # shellcheck source=/dev/null
        source "${ZSH_GITHUB_CONF_PATH}/completions.zsh"
    fi
}

github::internal::main::factory

if core::exists gh; then
    github::internal::install_completions
    github::internal::load
fi