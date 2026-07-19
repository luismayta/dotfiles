# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_WAYBAR_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_WAYBAR_PATH}/pkg/osx.zsh" ;;
linux*)
  source "${ZSH_WAYBAR_PATH}/pkg/linux.zsh" ;;
esac

# shellcheck source=/dev/null
source "${ZSH_WAYBAR_PATH}/pkg/helper.zsh"
# shellcheck source=/dev/null
source "${ZSH_WAYBAR_PATH}/pkg/alias.zsh"
