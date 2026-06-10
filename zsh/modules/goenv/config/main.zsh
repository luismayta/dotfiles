#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# ==============================================================================
# File: main.zsh
# Description: goenv config layer entry point with OS dispatch
# ==============================================================================
# shellcheck shell=bash

source "${GOENV_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*) source "${GOENV_PATH}/config/osx.zsh" ;;
linux*) source "${GOENV_PATH}/config/linux.zsh" ;;
esac
