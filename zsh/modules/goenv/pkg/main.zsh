#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# ==============================================================================
# File: main.zsh
# Description: goenv pkg layer entry point with OS dispatch
# ==============================================================================
# shellcheck shell=bash

# shellcheck source=/dev/null
source "${GOENV_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${GOENV_PATH}/pkg/osx.zsh" ;;
linux*)
    # shellcheck source=/dev/null
    source "${GOENV_PATH}/pkg/linux.zsh" ;;
esac

# shellcheck source=/dev/null
source "${GOENV_PATH}/pkg/helper.zsh"
# shellcheck source=/dev/null
source "${GOENV_PATH}/pkg/alias.zsh"
