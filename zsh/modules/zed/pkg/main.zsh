# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZED_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZED_PATH}/pkg/osx.zsh" ;;
linux*)
  source "${ZED_PATH}/pkg/linux.zsh" ;;
esac

# shellcheck source=/dev/null
source "${ZED_PATH}/pkg/helper.zsh"
# shellcheck source=/dev/null
source "${ZED_PATH}/pkg/alias.zsh"
