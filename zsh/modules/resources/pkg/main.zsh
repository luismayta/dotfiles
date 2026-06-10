# shellcheck source=/dev/null
# shellcheck shell=bash
source "${RESOURCES_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${RESOURCES_PATH}/pkg/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${RESOURCES_PATH}/pkg/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${RESOURCES_PATH}/pkg/helper.zsh"

# shellcheck source=/dev/null
source "${RESOURCES_PATH}/pkg/alias.zsh"
