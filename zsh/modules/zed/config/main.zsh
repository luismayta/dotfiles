# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_ZED_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_ZED_PATH}/config/osx.zsh" ;;
linux*)
  source "${ZSH_ZED_PATH}/config/linux.zsh" ;;
esac
