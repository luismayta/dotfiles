#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::internal::main::factory {
    # shellcheck source=/dev/null
    source "${DOCKER_PATH}/internal/base.zsh"
    case "${OSTYPE}" in
    darwin*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/osx.zsh" ;;
    linux*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/linux.zsh" ;;
    esac

    case "${DOCKER_CONTAINER_APP_NAME}" in
      colima*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/colima.zsh" ;;
      lima*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/lima.zsh" ;;
      podman*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/podman.zsh" ;;
      docker*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/docker.zsh" ;;
      orbstack*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/orbstack.zsh" ;;
    esac
    # shellcheck source=/dev/null
    source "${DOCKER_PATH}/internal/helper.zsh"
}

docker::internal::main::factory

container::internal::container::install
container::internal::container::load
