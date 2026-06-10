#
# Pkg main — sources all package modules
#

# shellcheck source=/dev/null
source "${CORE_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${CORE_PATH}/pkg/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${CORE_PATH}/pkg/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${CORE_PATH}/pkg/helper/main.zsh"

# shellcheck source=/dev/null
source "${CORE_PATH}/pkg/docker.zsh"

# shellcheck source=/dev/null
source "${CORE_PATH}/pkg/alias.zsh"
