#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# ==============================================================================
# File: main.zsh
# Description: goenv config layer entry point with OS dispatch
# ==============================================================================
# shellcheck shell=bash

# shellcheck source=/dev/null
source "${GOENV_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${GOENV_PATH}/config/osx.zsh" ;;
linux*)
    # shellcheck source=/dev/null
    source "${GOENV_PATH}/config/linux.zsh" ;;
esac
