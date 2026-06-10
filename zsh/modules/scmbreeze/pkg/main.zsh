# shellcheck source=/dev/null
# shellcheck shell=bash
source "${ZSH_SCMBREEZE_PATH}/pkg/base.zsh"
case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_SCMBREEZE_PATH}/pkg/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_SCMBREEZE_PATH}/pkg/linux.zsh"
  ;;
esac
