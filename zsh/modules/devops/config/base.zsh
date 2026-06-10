#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

export DEVOPS_PACKAGE_NAME=devops

export DEVOPS_TOOLS=(
  sops
  packer
  telepresenceio/telepresence/telepresence-oss
)

export DEVOPS_PACKAGES=(
    "${DEVOPS_TOOLS[@]}"
)
