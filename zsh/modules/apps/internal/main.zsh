# shellcheck shell=bash
# shellcheck disable=SC1091
source "${ZSH_APPS_PATH}/internal/base.zsh"
source "${ZSH_APPS_PATH}/internal/build.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_APPS_PATH}/internal/osx.zsh" ;;
linux*)
  source "${ZSH_APPS_PATH}/internal/linux.zsh" ;;
esac

core::ensure curl