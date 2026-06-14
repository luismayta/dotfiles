# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZED_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZED_PATH}/config/osx.zsh" ;;
linux*)
  source "${ZED_PATH}/config/linux.zsh" ;;
esac
