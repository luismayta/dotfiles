# shellcheck shell=bash
# shellcheck source=/dev/null
source "${AI_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${AI_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${AI_PATH}/internal/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${AI_PATH}/internal/helper.zsh"

ai::internal::opencode::load
ai::internal::shimmy::load
