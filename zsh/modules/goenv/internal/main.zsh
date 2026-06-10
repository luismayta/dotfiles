#!/usr/bin/env ksh
# -*- coding: utf-8 -*-
# ==============================================================================
# File: main.zsh
# Description: goenv internal layer entry point with OS dispatch
# ==============================================================================
# shellcheck shell=bash

# shellcheck source=/dev/null
source "${GOENV_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${GOENV_PATH}/internal/osx.zsh" ;;
linux*)
    # shellcheck source=/dev/null
    source "${GOENV_PATH}/internal/linux.zsh" ;;
esac

# shellcheck source=/dev/null
source "${GOENV_PATH}/internal/helper.zsh"

goenv::internal::load

core::ensure curl
if ! core::exists gobrew; then goenv::internal::install; fi
