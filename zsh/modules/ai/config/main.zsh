# shellcheck shell=bash
# shellcheck source=/dev/null
source "${AI_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${AI_PATH}/config/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${AI_PATH}/config/linux.zsh"
  ;;
esac
