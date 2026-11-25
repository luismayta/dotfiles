#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::gcloud::internal::completion::inc::path {
    # Resolve without forking gcloud: a cache hit must stay fork-free.
    REPLY=""
    local bin_path="${commands[gcloud]:-}"
    local -a candidates=()
    if [[ -n "${bin_path}" ]]; then
        candidates+=("${bin_path:A:h:h}/completion.zsh.inc")
    fi
    candidates+=(
        /usr/share/google-cloud-sdk/completion.zsh.inc
        /opt/google-cloud-sdk/completion.zsh.inc
        /opt/google-cloud-cli/completion.zsh.inc
        /usr/lib/google-cloud-sdk/completion.zsh.inc
        "${HOME}/.local/share/google-cloud-sdk/completion.zsh.inc"
        "${HOME}/.google-cloud-sdk/completion.zsh.inc"
    )
    local candidate
    for candidate in "${candidates[@]}"; do
        if [[ -f "${candidate}" ]]; then
            REPLY="${candidate}"
            return 0
        fi
    done
    return 1
}

function devops::gcloud::internal::load::completion {
    if core::exists gcloud; then
        devops::gcloud::internal::completion::inc::path
        devops::internal::completion::cached gcloud --source "${REPLY:-}"
        # shellcheck disable=SC2154 # zsh builtins (functions) not assigned in shellcheck
        if (( $+functions[_bash_complete] && ! $+functions[_gcloud] )); then
            function _gcloud { _bash_complete -o nospace -o default -F _python_argcomplete "$@"; }
            compdef _gcloud gcloud 2>/dev/null || true
        fi
        # make gsutil and bq completion work
        local subcommand
        for subcommand in gsutil bq; do
            core::exists "${subcommand}" || continue
            compdef "${subcommand}=google-cloud-sdk" 2>/dev/null || true
        done
    fi
}

function devops::gcloud::auth::login {
    gcloud auth login "$@"
}

function devops::gcloud::auth::application_default {
    gcloud auth application-default login "$@"
}

function devops::gcloud::components::install {
    if ! core::exists gcloud; then
        message_warning "gcloud is required. Run devops::gcloud::install first."
        return
    fi
    message_info "Installing required gcloud components"
    gcloud components install gke-gcloud-auth-plugin --quiet
    message_success "Installed required gcloud components"
}

function devops::gcloud::internal::main::factory {
    devops::gcloud::internal::load::completion

    if ! core::exists gcloud; then
        devops::gcloud::internal::install
    fi
}

devops::gcloud::internal::main::factory
