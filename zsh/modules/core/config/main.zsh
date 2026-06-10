#
# Config main — sources base.zsh + OS-specific overrides
#

# shellcheck source=/dev/null
source "${CORE_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${CORE_PATH}/config/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${CORE_PATH}/config/linux.zsh"
  ;;
esac
