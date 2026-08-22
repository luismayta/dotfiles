#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::gcloud::internal::load::completion {
    if core::exists gcloud; then
        # shellcheck source=/dev/null
        source <(gcloud --quiet completion zsh 2>/dev/null)
        # make gsutil and bq completion work
        if command -v gsutil >/dev/null 2>&1; then
            compdef gsutil=google-cloud-sdk 2>/dev/null || true
        fi
        if command -v bq >/dev/null 2>&1; then
            compdef bq=google-cloud-sdk 2>/dev/null || true
        fi
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
