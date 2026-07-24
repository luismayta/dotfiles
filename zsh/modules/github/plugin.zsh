#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# Guard variable to prevent double-loading
if [[ -n "${__ZSH_GITHUB_LOADED}" ]]; then
    return 0
fi

# Module enable/disable toggle
if [[ "${ZSH_GITHUB_ENABLED}" == "false" || "${ZSH_GITHUB_ENABLED}" == "0" ]]; then
    return 0
fi

# Set module path
typeset -gr ZSH_GITHUB_PATH="${ZSH_MODULES_PATH}/github"

# Source config layer
# shellcheck source=/dev/null
source "${ZSH_GITHUB_PATH}/config/gh.zsh"

# Source internal layer
# shellcheck source=/dev/null
source "${ZSH_GITHUB_PATH}/internal/gh.zsh"

# Source pkg layer
# shellcheck source=/dev/null
source "${ZSH_GITHUB_PATH}/pkg/gh.zsh"

# Set guard variable
typeset -gr __ZSH_GITHUB_LOADED=1
