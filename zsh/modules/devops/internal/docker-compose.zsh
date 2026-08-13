#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function devops::docker-compose::internal::load {
    if ! core::exists docker-compose; then
        return
    fi
}

function devops::docker-compose::internal::install {
    if core::exists docker-compose; then
        message_info "${DEVOPS_DOCKER_COMPOSE_PACKAGE_NAME} already installed"
        return 0
    fi

    message_info "Installing ${DEVOPS_DOCKER_COMPOSE_PACKAGE_NAME}"
    core::install "${DEVOPS_DOCKER_COMPOSE_PACKAGE_NAME}"
    message_success "Installed ${DEVOPS_DOCKER_COMPOSE_PACKAGE_NAME}"
}

function devops::docker-compose::internal::upgrade {
    if ! core::exists docker-compose; then
        devops::docker-compose::internal::install
        return
    fi

    message_info "Upgrading ${DEVOPS_DOCKER_COMPOSE_PACKAGE_NAME}"
    core::install "${DEVOPS_DOCKER_COMPOSE_PACKAGE_NAME}"
    message_success "Upgraded ${DEVOPS_DOCKER_COMPOSE_PACKAGE_NAME}"
}

function devops::docker-compose::internal::main::factory {
    core::ensure docker-compose
}

devops::docker-compose::internal::load
devops::docker-compose::internal::main::factory