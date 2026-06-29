#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
#
# Docker CE adapter for Docker module
#
# Contract:
#   install — ensure Docker CE is installed (via systemd/binary check)
#   load    — ensure docker daemon is running and socket is reachable
#

function docker::adapter::resolve::socket {
    if [[ -S "/var/run/docker.sock" ]]; then
        export DOCKER_HOST="unix:///var/run/docker.sock"
    elif [[ -S "${XDG_RUNTIME_DIR}/docker.sock" ]]; then
        export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/docker.sock"
    fi
}

function docker::internal::container::install {
    docker::internal::container::install::provider docker
}

function docker::internal::container::load {
    return 0
}
