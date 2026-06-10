#
# Internal main — sources all internal modules
#

# shellcheck source=/dev/null
source "${CORE_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${CORE_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${CORE_PATH}/internal/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${CORE_PATH}/internal/git.zsh"

# shellcheck source=/dev/null
source "${CORE_PATH}/internal/backup.zsh"
