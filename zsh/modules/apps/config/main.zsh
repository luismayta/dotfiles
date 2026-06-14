# shellcheck shell=bash
source "${ZSH_APPS_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_APPS_PATH}/config/osx.zsh" ;;
linux*)
  source "${ZSH_APPS_PATH}/config/linux.zsh" ;;
esac
