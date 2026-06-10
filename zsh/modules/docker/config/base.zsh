#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

export DOCKER_PACKAGE_NAME=docker
export DOCKER_CONTAINER_APP_NAME="${JASPER_CONTAINER_APP_NAME:-orbstack}"
export DOCKER_PODMAN_MACHINE_NAME="podman-machine-default"
export DOCKER_LIMA_MACHINE_NAME="default"
export DOCKER_MESSAGE_BREW="Please install brew or use antibody bundle hadenlabs/zsh-brew"
export DOCKER_MESSAGE_YAY="Please install Go or use antibody bundle hadenlabs/zsh-goenv"
export DOCKER_MESSAGE_RVM="Please install rvm or use antibody bundle hadenlabs/zsh-rvm"
export DOCKER_MESSAGE_NVM="Please install nvm or use antibody bundle hadenlabs/zsh-nvm"
