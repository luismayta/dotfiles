#!/usr/bin/env zsh
#
# Config layer - OS dispatch.
# Sources configuration variables and OS-specific overrides.

source "${ZSH_NVIM_PATH}/config/base.zsh"

case "${OSTYPE}" in
  darwin*)
    source "${ZSH_NVIM_PATH}/config/osx.zsh"
    ;;
  linux*)
    source "${ZSH_NVIM_PATH}/config/linux.zsh"
    ;;
esac
