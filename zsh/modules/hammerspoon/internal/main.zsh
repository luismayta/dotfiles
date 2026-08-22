# shellcheck shell=bash
# shellcheck source=/dev/null
source "${HAMMERSPOON_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${HAMMERSPOON_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${HAMMERSPOON_PATH}/internal/linux.zsh"
  ;;
esac

if ! core::exists rsync; then core::install rsync; fi
