# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_OSX_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_OSX_PATH}/config/osx.zsh" ;;
linux*)
  source "${ZSH_OSX_PATH}/config/linux.zsh" ;;
esac
