#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# Colima-specific Docker configuration
# Sourced by config/main.zsh when DOCKER_CONTAINER_APP_NAME is colima*

# Colima machine name (default: colima)
export DOCKER_COLIMA_MACHINE_NAME="${DOCKER_COLIMA_MACHINE_NAME:-colima}"

# Colima Docker socket path — resolved dynamically via colima status --json
