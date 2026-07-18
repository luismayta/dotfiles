# shellcheck shell=bash
source "${ZSH_KEYBASE_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_KEYBASE_PATH}/pkg/osx.zsh" ;;
linux*)
  source "${ZSH_KEYBASE_PATH}/pkg/linux.zsh" ;;
esac

source "${ZSH_KEYBASE_PATH}/pkg/helper.zsh"
source "${ZSH_KEYBASE_PATH}/pkg/alias.zsh"
