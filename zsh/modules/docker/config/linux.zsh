#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# Linux-specific Docker configuration
# Sourced by config/main.zsh after base.zsh when OSTYPE is linux*

# Default provider for Linux
export DOCKER_CONTAINER_APP_NAME="${DOCKER_CONTAINER_APP_NAME:-docker}"

# Default Docker socket path on Linux
export DOCKER_SOCKET_PATH="${DOCKER_SOCKET_PATH:-/var/run/docker.sock}"

# Docker group name on Linux
export DOCKER_GROUP_NAME="${DOCKER_GROUP_NAME:-docker}"

# Rootless Docker detection — prefer user-scoped socket if available
if [[ -z "${DOCKER_HOST:-}" && -z "${DOCKER_SOCKET_PATH:-}" && -S "${XDG_RUNTIME_DIR}/docker.sock" ]]; then
    export DOCKER_SOCKET_PATH="${XDG_RUNTIME_DIR}/docker.sock"
fi

# Provider auto-detection: check which container runtimes are installed
export DOCKER_AVAILABLE_PROVIDERS=()
core::exists docker  && DOCKER_AVAILABLE_PROVIDERS+=(docker)
core::exists podman  && DOCKER_AVAILABLE_PROVIDERS+=(podman)
core::exists limactl && DOCKER_AVAILABLE_PROVIDERS+=(lima)
