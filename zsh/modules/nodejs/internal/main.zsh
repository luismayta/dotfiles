# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_NODEJS_PATH}/internal/base.zsh"
case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_NODEJS_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_NODEJS_PATH}/internal/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${ZSH_NODEJS_PATH}/internal/helper.zsh"
