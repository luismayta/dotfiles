#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# Nix-direnv configuration
export NIX_DIRENV_PACKAGE_NAME=nix-direnv
export NIX_DIRENV_NIX_PACKAGE="nixpkgs#nix-direnv"
export NIX_DIRENV_DATA_PATH="${NIX_DATA_PATH}/direnv"
export NIX_DIRENV_CONFIG_DIR="${HOME}/.config/direnv"
