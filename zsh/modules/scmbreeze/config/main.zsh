# shellcheck shell=bash

# shellcheck source=/dev/null
source "${ZSH_SCMBREEZE_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_SCMBREEZE_PATH}/config/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_SCMBREEZE_PATH}/config/linux.zsh"
  ;;
esac
