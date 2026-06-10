#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

export DEVOPS_MESSAGE_BREW="Please install brew or use antibody bundle luismayta/zsh-brew"
export DEVOPS_PACKAGE_NAME=devops

export DEVOPS_TOOLS=(
  sops
  packer
  telepresenceio/telepresence/telepresence-oss
)

export DEVOPS_PACKAGES=(
    "${DEVOPS_TOOLS[@]}"
)
