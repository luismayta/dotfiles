#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::config::main::factory {
    # shellcheck source=/dev/null
    source "${DOCKER_PATH}/config/base.zsh"
    case "${OSTYPE}" in
    darwin*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/osx.zsh" ;;
    linux*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/linux.zsh" ;;
    esac

    case "${DOCKER_CONTAINER_APP_NAME}" in
      colima*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/colima.zsh" ;;
      lima*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/lima.zsh" ;;
      podman*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/podman.zsh" ;;
      docker*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/docker.zsh" ;;
      orbstack*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/orbstack.zsh" ;;
    esac
}

docker::config::main::factory
container::core
