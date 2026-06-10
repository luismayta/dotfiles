# shellcheck source=/dev/null
# shellcheck shell=bash
source "${ISSUES_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ISSUES_PATH}/pkg/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ISSUES_PATH}/pkg/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${ISSUES_PATH}/pkg/helper.zsh"

# shellcheck source=/dev/null
source "${ISSUES_PATH}/pkg/alias.zsh"
