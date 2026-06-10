#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# ==============================================================================
# File: plugin.zsh
# Description: goenv module entry point
# ==============================================================================
# shellcheck shell=bash

[[ -n "${__ZSH_GOENV_LOADED:-}" ]] && return
__ZSH_GOENV_LOADED=1

GOENV_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${GOENV_PATH}/config/main.zsh"
# shellcheck source=/dev/null
source "${GOENV_PATH}/internal/main.zsh"
# shellcheck source=/dev/null
source "${GOENV_PATH}/pkg/main.zsh"
