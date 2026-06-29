#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
#
# Lima adapter for Docker module
#
# Contract:
#   install — ensure Lima is installed
#   load    — ensure Lima machine exists, is running, and docker socket is reachable
#

function docker::adapter::resolve::socket {
    local lima_socket="${HOME}/.lima/${DOCKER_LIMA_MACHINE_NAME}/sock/docker.sock"
    if [[ -S "${lima_socket}" ]]; then
        export DOCKER_HOST="unix://${lima_socket}"
    fi
}

function docker::internal::container::install {
    docker::internal::container::install::provider lima
}

function docker::internal::container::load {
    local machine_name="${DOCKER_LIMA_MACHINE_NAME:-default}"

    if ! core::exists jq; then
        message_error "'jq' is required but not installed."; return 1
    fi

    if ! limactl list --json | jq -e --arg name "$machine_name" '.[] | select(.name == $name)' >/dev/null; then
        message_info "Lima machine '${machine_name}' does not exist. Initializing..."
        limactl start "$machine_name"; return
    fi

    local running
    running=$(limactl list --json | jq -r --arg name "$machine_name" '.[] | select(.name == $name) | .state')

    if [[ "$running" != "Running" ]]; then
        message_info "Lima machine '${machine_name}' exists but is not running. Starting..."
        limactl start "$machine_name"
    else
        message_success "Lima machine '${machine_name}' is already running."
    fi
}
