#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
#
# Podman adapter for Docker module
#
# Contract:
#   install — ensure Podman is installed
#   load    — ensure Podman machine exists, is running, and socket is reachable
#

function docker::adapter::resolve::socket {
    local podman_socket="unix:///run/user/${UID}/podman/podman.sock"
    if [[ -S "/run/user/${UID}/podman/podman.sock" ]]; then
        export DOCKER_HOST="${podman_socket}"
    fi
}

function docker::internal::container::install {
    docker::internal::container::install::provider podman
}

function docker::internal::container::load {
    local machine_name="${DOCKER_PODMAN_MACHINE_NAME:-podman-machine-default}"

    if ! core::exists jq; then
        message_error "'jq' is required but not installed."; return 1
    fi

    if ! podman machine list | grep -q "${machine_name}"; then
        message_info "Podman machine '${machine_name}' not found. Initializing..."
        podman machine init --now --name "${machine_name}"; return
    fi

    local running
    running=$(podman machine list --format json | jq -r \
        --arg name "$machine_name" '.[] | select(.Name == $name) | .Running')

    if [[ "${running}" != "true" ]]; then
        message_info "Podman machine '${machine_name}' exists but is not running. Starting..."
        podman machine start "${machine_name}"
    fi
}
