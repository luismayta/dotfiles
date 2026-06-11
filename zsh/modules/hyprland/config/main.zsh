# shellcheck shell=bash
# shellcheck source=/dev/null
source "${HYPRLAND_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${HYPRLAND_PATH}/config/osx.zsh" ;;
linux*)
  source "${HYPRLAND_PATH}/config/linux.zsh" ;;
esac
