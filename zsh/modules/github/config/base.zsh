#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

ZSH_GITHUB_ENABLED="${ZSH_GITHUB_ENABLED:-true}"

# GitHub CLI configuration
export ZSH_GITHUB_PACKAGE_NAME=gh
export ZSH_GITHUB_CONF_PATH="${HOME}/.config/gh"
export ZSH_GITHUB_DASH_CONF_PATH="${HOME}/.config/gh-dash"
export ZSH_GITHUB_DATA_PATH="${ZSH_GITHUB_PATH}/data"
export ZSH_GITHUB_DATA_GH_DASH_PATH="${ZSH_GITHUB_DATA_PATH}/gh-dash"

# gh extensions (krew-style config array)
export ZSH_GITHUB_EXTENSIONS=(
    dlvhdr/gh-dash
)