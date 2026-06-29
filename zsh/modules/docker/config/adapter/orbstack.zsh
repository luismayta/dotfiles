#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# Orbstack-specific Docker configuration
# Sourced by config/main.zsh when DOCKER_CONTAINER_APP_NAME is orbstack*

# Orbstack Docker socket path
export DOCKER_ORBSTACK_SOCKET="${HOME}/.orbstack/run/docker.sock"
