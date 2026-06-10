#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::pkg::main::factory {
    source "${DOCKER_PATH}/pkg/base.zsh"
    case "${OSTYPE}" in
    darwin*) source "${DOCKER_PATH}/pkg/osx.zsh" ;;
    linux*)  source "${DOCKER_PATH}/pkg/linux.zsh" ;;
    esac
    source "${DOCKER_PATH}/pkg/helper.zsh"
    source "${DOCKER_PATH}/pkg/alias.zsh"
}

docker::pkg::main::factory
