#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function docker::pkg::main::factory {
    # shellcheck source=/dev/null
    source "${DOCKER_PATH}/pkg/base.zsh"
    # shellcheck source=/dev/null
    source "${DOCKER_PATH}/pkg/alias.zsh"

    # OS-level dispatch (stubs for future platform-specific public functions)
    case "${OSTYPE}" in
      darwin*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/pkg/osx.zsh" ;;
      linux*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/pkg/linux.zsh" ;;
    esac
}

docker::pkg::main::factory
