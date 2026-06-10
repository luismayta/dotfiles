#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::tfenv::internal::tfenv::install {
    message_info "Installing ${DEVOPS_TFENV_PACKAGE_NAME}"
    git clone https://github.com/tfutils/tfenv.git ~/.tfenv
    devops::tfenv::internal::tfenv::load
    message_success "Installed ${DEVOPS_TFENV_PACKAGE_NAME}"
}

function devops::tfenv::internal::tfenv::load {
    [ -e "${DEVOPS_TFENV_ROOT_BIN}" ] && export PATH="${PATH}:${DEVOPS_TFENV_ROOT_BIN}"
}

function devops::tfenv::internal::version::all::install {
    if ! core::exists tfenv; then
        message_warning "not found tfenv"
        return
    fi

    for version in "${DEVOPS_TFENV_VERSIONS[@]}"; do
        message_info "Install version of terraform ${version}"
        tfenv install "${version}"
        message_success "Installed version of terraform ${version}"
    done
    tfenv global "${DEVOPS_TFENV_VERSION_GLOBAL}"
    message_success "Installed versions of Terraform"
}

function devops::tfenv::internal::version::global::install {
    if ! core::exists tfenv; then
        message_warning "not found tfenv"
        return
    fi
    message_info "Installing version global of terraform ${DEVOPS_TFENV_VERSION_GLOBAL}"
    tfenv install "${DEVOPS_TFENV_VERSION_GLOBAL}"
    tfenv use "${DEVOPS_TFENV_VERSION_GLOBAL}"
    message_success "Installed version global of terraform ${DEVOPS_TFENV_VERSION_GLOBAL}"
}

function devops::tfenv::internal::tfenv::upgrade {
    message_info "Upgrade for ${DEVOPS_TFENV_PACKAGE_NAME}"
    local path_tfenv
    path_tfenv=$(tfenv root)
    # shellcheck disable=SC2164
    cd "${path_tfenv}" && git pull && cd -
    message_success "Upgraded ${DEVOPS_TFENV_PACKAGE_NAME}"
}

function devops::tfenv::internal::main::factory {
    devops::tfenv::internal::tfenv::load

    core::ensure curl
    core::ensure terragrunt
    core::ensure terraform-docs
    if ! core::exists tfenv; then devops::tfenv::internal::tfenv::install; fi
}

devops::tfenv::internal::main::factory
