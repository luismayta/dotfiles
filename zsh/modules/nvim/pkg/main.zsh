# shellcheck shell=bash
# shellcheck disable=SC1091
#
# Pkg layer - OS dispatch.
# Sources public API, OS-specific files, aliases, and helpers.

source "${ZSH_NVIM_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
  darwin*)
    source "${ZSH_NVIM_PATH}/pkg/osx.zsh"
    ;;
  linux*)
    source "${ZSH_NVIM_PATH}/pkg/linux.zsh"
    ;;
esac

source "${ZSH_NVIM_PATH}/pkg/alias.zsh"
source "${ZSH_NVIM_PATH}/pkg/helper.zsh"
