# shellcheck shell=bash
# shellcheck disable=SC1091
#
# Pkg layer - OS dispatch.
# Sources public API, OS-specific files, and helpers.

source "${ZSH_HELIX_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
  darwin*)
    source "${ZSH_HELIX_PATH}/pkg/osx.zsh"
    ;;
  linux*)
    source "${ZSH_HELIX_PATH}/pkg/linux.zsh"
    ;;
esac

source "${ZSH_HELIX_PATH}/pkg/helper.zsh"
