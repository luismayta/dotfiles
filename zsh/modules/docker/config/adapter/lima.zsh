#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# Lima-specific Docker configuration
# Sourced by config/main.zsh when DOCKER_CONTAINER_APP_NAME is lima*

# Lima machine name (default: default)
export DOCKER_LIMA_MACHINE_NAME="${DOCKER_LIMA_MACHINE_NAME:-default}"

# Lima Docker socket path — resolved dynamically via limactl list --json
