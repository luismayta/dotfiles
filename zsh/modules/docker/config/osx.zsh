#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# macOS-specific Docker configuration
# Sourced by config/main.zsh after base.zsh when OSTYPE is darwin*

# Default provider for macOS
export DOCKER_CONTAINER_APP_NAME="${DOCKER_CONTAINER_APP_NAME:-orbstack}"

# macOS Docker socket path — provider-resolved in internal layer
export DOCKER_SOCKET_PATH="${DOCKER_SOCKET_PATH:-}"

# Docker Desktop application path for macOS
export DOCKER_DESKTOP_APP="/Applications/Docker.app"

# Homebrew prefix for macOS
export DOCKER_BREW_PREFIX="${DOCKER_BREW_PREFIX:-$(brew --prefix 2>/dev/null)}"

# Provider auto-detection: check which container runtimes are installed
export DOCKER_AVAILABLE_PROVIDERS=()
core::exists orbstack  && DOCKER_AVAILABLE_PROVIDERS+=(orbstack)
core::exists colima    && DOCKER_AVAILABLE_PROVIDERS+=(colima)
core::exists docker    && DOCKER_AVAILABLE_PROVIDERS+=(docker)
core::exists limactl   && DOCKER_AVAILABLE_PROVIDERS+=(lima)
core::exists podman    && DOCKER_AVAILABLE_PROVIDERS+=(podman)
