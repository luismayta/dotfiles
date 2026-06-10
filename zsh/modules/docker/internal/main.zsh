#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::internal::main::factory {
    source "${DOCKER_PATH}/internal/base.zsh"
    case "${OSTYPE}" in
    darwin*) source "${DOCKER_PATH}/internal/osx.zsh" ;;
    linux*)  source "${DOCKER_PATH}/internal/linux.zsh" ;;
    esac

    case "${DOCKER_CONTAINER_APP_NAME}" in
      colima*)  source "${DOCKER_PATH}/internal/colima.zsh" ;;
      lima*)    source "${DOCKER_PATH}/internal/lima.zsh" ;;
      podman*)  source "${DOCKER_PATH}/internal/podman.zsh" ;;
      docker*)  source "${DOCKER_PATH}/internal/docker.zsh" ;;
      orbstack*)source "${DOCKER_PATH}/internal/orbstack.zsh" ;;
    esac
    source "${DOCKER_PATH}/internal/helper.zsh"
}

docker::internal::main::factory

container::internal::container::install
container::internal::container::load
