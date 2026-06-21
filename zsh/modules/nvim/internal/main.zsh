# shellcheck shell=bash
# shellcheck disable=SC1091
#
# Internal layer - OS dispatch.
# Sources OS-specific overrides after the core logic.

source "${ZSH_NVIM_PATH}/internal/base.zsh"

case "${OSTYPE}" in
  darwin*)
    source "${ZSH_NVIM_PATH}/internal/osx.zsh"
    ;;
  linux*)
    source "${ZSH_NVIM_PATH}/internal/linux.zsh"
    ;;
esac
