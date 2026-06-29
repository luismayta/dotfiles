#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
#
# Colima adapter for Docker module
#
# Contract:
#   install — ensure Colima is installed. If docker CLI is missing, install it too.
#   load    — ensure colima daemon is running and docker socket is reachable
#

function docker::adapter::resolve::socket {
    local colima_socket="${HOME}/.colima/default/docker.sock"
    if [[ -S "${colima_socket}" ]]; then
        export DOCKER_HOST="unix://${colima_socket}"
    fi
}

function docker::internal::check::dependency {
    if ! core::exists "${1}"; then
        message_error "'${1}' is required but not installed."
        return 1
    fi
}

function docker::internal::container::install {
    docker::internal::container::install::provider colima
    if ! core::exists docker; then core::install docker; fi
}

function docker::internal::container::load {
    docker::internal::check::dependency jq || return 1
    docker::internal::check::dependency colima || return 1

    local docker_socket
    docker_socket=$(colima status --json 2>/dev/null | jq -r '.docker_socket // empty')

    if [[ -z "$docker_socket" ]]; then
        message_info "Colima is not running. Starting it..."
        colima start
    fi
}
