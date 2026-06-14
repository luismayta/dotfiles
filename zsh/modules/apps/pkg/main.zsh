# shellcheck shell=bash
# shellcheck disable=SC1091
source "${ZSH_APPS_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_APPS_PATH}/pkg/osx.zsh" ;;
linux*)
  source "${ZSH_APPS_PATH}/pkg/linux.zsh" ;;
esac

source "${ZSH_APPS_PATH}/pkg/helper.zsh"
source "${ZSH_APPS_PATH}/pkg/alias.zsh"
