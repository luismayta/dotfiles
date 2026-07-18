# shellcheck shell=bash
source "${ZSH_KEYBASE_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_KEYBASE_PATH}/config/osx.zsh" ;;
linux*)
  source "${ZSH_KEYBASE_PATH}/config/linux.zsh" ;;
esac
