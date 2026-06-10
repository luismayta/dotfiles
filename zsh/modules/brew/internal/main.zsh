# shellcheck shell=bash
case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${BREW_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${BREW_PATH}/internal/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${BREW_PATH}/internal/base.zsh"
