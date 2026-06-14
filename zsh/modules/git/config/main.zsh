# shellcheck shell=bash

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/config/base.zsh"

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/config/git.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_GIT_PATH}/config/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_GIT_PATH}/config/linux.zsh"
  ;;
esac
