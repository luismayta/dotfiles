# shellcheck shell=bash
source "${ZSH_APPS_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_APPS_PATH}/internal/osx.zsh" ;;
linux*)
  source "${ZSH_APPS_PATH}/internal/linux.zsh" ;;
esac

core::ensure curl