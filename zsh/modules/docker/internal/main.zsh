#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# ──────────────────────────────────────────────────────────────────────────────
# OS → Provider override pattern for install/load
#
# The install and load functions follow a layered resolution:
#   1. OS-level (osx.zsh / linux.zsh) defines the PLATFORM default:
#      - macOS: Docker Desktop.app detection + launch
#      - Linux: systemd service enable + start
#   2. Provider-level (colima.zsh, lima.zsh, podman.zsh, docker.zsh, orbstack.zsh)
#      OVERRIDES install/load with provider-specific logic.
#
# This means the LAST source wins. For example, with DOCKER_CONTAINER_APP_NAME=colima:
#   osx.zsh defines docker::internal::container::install (Docker Desktop)
#   → colima.zsh redefines docker::internal::container::install (colima start)
# The colima implementation is the active one.
#
# If adding a new provider, define BOTH install AND load in its file,
# otherwise the OS-level defaults will be used.
# ──────────────────────────────────────────────────────────────────────────────

function docker::internal::main::factory {
    # shellcheck source=/dev/null
    source "${DOCKER_PATH}/internal/base.zsh"

    # OS-level dispatch — must come before provider dispatch
    case "${OSTYPE}" in
      darwin*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/osx.zsh" ;;
      linux*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/linux.zsh" ;;
    esac

    # Provider-level dispatch
    case "${DOCKER_CONTAINER_APP_NAME}" in
      colima*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/adapter/colima.zsh" ;;
      lima*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/adapter/lima.zsh" ;;
      podman*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/adapter/podman.zsh" ;;
      docker*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/adapter/docker.zsh" ;;
      orbstack*)
        # shellcheck source=/dev/null
        source "${DOCKER_PATH}/internal/adapter/orbstack.zsh" ;;
    esac

    # DOCKER_HOST auto-resolution
    docker::internal::resolve::socket

    # Health check
    docker::internal::health::check
}

docker::internal::main::factory
# Only attempt install if docker binary is not found
if ! core::exists docker; then
    docker::internal::container::install
fi

# Only attempt load if docker binary exists but may not be running
if core::exists docker; then
    docker::internal::container::load
fi
