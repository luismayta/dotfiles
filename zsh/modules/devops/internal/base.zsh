#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::internal::packages::install {
    message_info "Installing required devops packages"
    for package in "${DEVOPS_PACKAGES[@]}"; do
        core::install "${package}"
    done
    message_success "Installed required devops packages"
}

function devops::internal::completion::cached {
    local tool="${1}" source_file=""
    shift
    if [[ "${1:-}" == "--source" ]]; then
        source_file="${2:-}"
        shift 2
    fi

    local bin_path
    bin_path="$(command -v "${tool}" 2>/dev/null)" || return 0

    local cache_dir="${DOTFILES_CACHE_PATH:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions}"
    local cache_file="${cache_dir}/${tool}-completion.zsh"
    local fresh_path="${source_file:-${bin_path}}"
    local stale=0

    # Invalidation: missing cache, reference newer (copied source, else binary), or older than 30 days.
    if [[ ! -f "${cache_file}" || "${fresh_path}" -nt "${cache_file}" ]]; then
        stale=1
    else
        zmodload zsh/stat 2>/dev/null
        zmodload zsh/datetime 2>/dev/null
        local -a mtime
        # shellcheck disable=SC2154 # zsh builtins (builtins, zstat) not assigned in shellcheck
        if (( $+builtins[zstat] )) && zstat -A mtime +mtime "${cache_file}" 2>/dev/null && (( ${#mtime} )); then
            (( EPOCHSECONDS - mtime[1] > 30 * 86400 )) && stale=1
        fi
    fi

    if (( stale )); then
        mkdir -p "${cache_dir}" 2>/dev/null
        local tmp_file=''
        tmp_file="$(mktemp "${cache_dir}/.completion.XXXXXX" 2>/dev/null)" || tmp_file=''
        if [[ -n "${tmp_file}" ]]; then
            local generated=1
            if [[ -n "${source_file}" ]]; then
                cp -f -- "${source_file}" "${tmp_file}" 2>/dev/null || generated=0
            else
                "$@" > "${tmp_file}" 2>/dev/null || generated=0
            fi
            # mv publishes atomically; a failed or empty write is discarded.
            if (( generated )) && [[ -s "${tmp_file}" ]]; then
                mv -f "${tmp_file}" "${cache_file}" || rm -f "${tmp_file}"
            else
                rm -f "${tmp_file}"
            fi
        fi
    fi

    if [[ -f "${cache_file}" ]]; then
        # shellcheck source=/dev/null
        source "${cache_file}"
    fi
    return 0
}

function devops::internal::go::packages::install {
    message_info "Installing required devops packages"
    for package in "${DEVOPS_GO_PACKAGES[@]}"; do
        goenv::package::install "${package}"
    done
    message_success "Installed required devops packages"
}
