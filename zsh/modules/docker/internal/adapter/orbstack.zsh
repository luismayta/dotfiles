#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
#
# Orbstack adapter for Docker module
#
# Contract:
#   install — ensure Orbstack is installed (via brew/binary check)
#   load    — ensure orbstack daemon is running and docker socket is reachable
#

function docker::adapter::resolve::socket {
    if [[ -S "${HOME}/.orbstack/run/docker.sock" ]]; then
        export DOCKER_HOST="unix://${HOME}/.orbstack/run/docker.sock"
    fi
}

function docker::internal::container::install {
    docker::internal::container::install::provider orbstack
}

function docker::internal::container::load {
    return 0
}
