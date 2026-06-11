# shellcheck shell=bash
# shellcheck source=/dev/null
source "${HYPRLAND_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${HYPRLAND_PATH}/internal/osx.zsh" ;;
linux*)
  source "${HYPRLAND_PATH}/internal/linux.zsh" ;;
esac
