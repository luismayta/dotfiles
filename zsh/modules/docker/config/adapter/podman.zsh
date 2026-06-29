#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# Podman-specific Docker configuration
# Sourced by config/main.zsh when DOCKER_CONTAINER_APP_NAME is podman*

# Podman machine name
export DOCKER_PODMAN_MACHINE_NAME="${DOCKER_PODMAN_MACHINE_NAME:-podman-machine-default}"

# Podman socket path — user-scoped by default
export DOCKER_PODMAN_SOCKET="unix:///run/user/${UID}/podman/podman.sock"
