# shellcheck source=/dev/null
# shellcheck shell=bash
source "${TEMPLATES_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${TEMPLATES_PATH}/pkg/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${TEMPLATES_PATH}/pkg/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${TEMPLATES_PATH}/pkg/helper.zsh"

# shellcheck source=/dev/null
source "${TEMPLATES_PATH}/pkg/alias.zsh"
