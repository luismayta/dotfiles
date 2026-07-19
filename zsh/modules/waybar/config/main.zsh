# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_WAYBAR_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_WAYBAR_PATH}/config/osx.zsh" ;;
linux*)
  source "${ZSH_WAYBAR_PATH}/config/linux.zsh" ;;
esac
