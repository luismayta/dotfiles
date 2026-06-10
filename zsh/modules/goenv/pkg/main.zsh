#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# ==============================================================================
# File: main.zsh
# Description: goenv pkg layer entry point with OS dispatch
# ==============================================================================
# shellcheck shell=bash

source "${GOENV_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*) source "${GOENV_PATH}/pkg/osx.zsh" ;;
linux*) source "${GOENV_PATH}/pkg/linux.zsh" ;;
esac

source "${GOENV_PATH}/pkg/helper.zsh"
source "${GOENV_PATH}/pkg/alias.zsh"
