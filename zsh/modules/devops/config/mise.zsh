#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# Mise configuration
export DEVOPS_MISE_PACKAGE_NAME=mise
export DEVOPS_MISE_NIX_PACKAGE="nixpkgs#mise"
if (( ! ${+DEVOPS_MISE_INIT_FLAGS} )); then
  export DEVOPS_MISE_INIT_FLAGS=()
fi
export DEVOPS_MISE_CONFIG_DIR="${HOME}/.config/mise"
export DEVOPS_MISE_CONFIG_FILE="${DEVOPS_MISE_CONFIG_DIR}/config.toml"
