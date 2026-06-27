#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
ZSH_DOCKER_ENABLED="${ZSH_DOCKER_ENABLED:-true}"

export DOCKER_PACKAGE_NAME=docker
export DOCKER_CONTAINER_APP_NAME="${JASPER_CONTAINER_APP_NAME:-orbstack}"
export DOCKER_PODMAN_MACHINE_NAME="podman-machine-default"
export DOCKER_LIMA_MACHINE_NAME="default"