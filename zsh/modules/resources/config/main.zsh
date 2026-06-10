# shellcheck shell=bash
case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${RESOURCES_PATH}/config/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${RESOURCES_PATH}/config/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${RESOURCES_PATH}/config/base.zsh"
