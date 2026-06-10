# shellcheck shell=bash
# Starship internal main loader

source "${ZSH_STARSHIP_PATH}/internal/base.zsh"

case "${OSTYPE}" in
  darwin*)
    source "${ZSH_STARSHIP_PATH}/internal/osx.zsh"
    ;;
  linux*)
    source "${ZSH_STARSHIP_PATH}/internal/linux.zsh"
    ;;
esac
