#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::config::main::factory {
    # shellcheck source=/dev/null
    source "${DOCKER_PATH}/config/base.zsh"

    # OS-level dispatch — must come before provider dispatch
    case "${OSTYPE}" in
      darwin*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/osx.zsh" ;;
      linux*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/linux.zsh" ;;
    esac

    # Provider-level dispatch
    case "${DOCKER_CONTAINER_APP_NAME}" in
      colima*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/adapter/colima.zsh" ;;
      lima*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/adapter/lima.zsh" ;;
      podman*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/adapter/podman.zsh" ;;
      orbstack*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/config/adapter/orbstack.zsh" ;;
    esac
}

docker::config::main::factory
