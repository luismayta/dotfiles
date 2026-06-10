# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_SCMBREEZE_PATH}/internal/base.zsh"
case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_SCMBREEZE_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_SCMBREEZE_PATH}/internal/linux.zsh"
  ;;
esac

# Auto-load scmbreeze if installed
scmbreeze::internal::load

# Ensure git is available
core::ensure git

# Auto-install if not present
if [ ! -e "${SCMBREEZE_ROOT}" ]; then
  scmbreeze::internal::install
fi
