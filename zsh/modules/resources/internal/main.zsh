# shellcheck shell=bash
# shellcheck source=/dev/null
source "${RESOURCES_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${RESOURCES_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${RESOURCES_PATH}/internal/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${RESOURCES_PATH}/internal/helper.zsh"

# shellcheck source=/dev/null
source "${RESOURCES_PATH}/internal/packages.zsh"

if ! core::exists rsync; then core::install rsync; fi
