#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::pkg::main::factory {
    # shellcheck source=/dev/null
    source "${DOCKER_PATH}/pkg/base.zsh"
    # shellcheck source=/dev/null
    source "${DOCKER_PATH}/pkg/alias.zsh"
}

docker::pkg::main::factory
