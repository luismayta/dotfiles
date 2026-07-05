# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_HERDR_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_HERDR_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_HERDR_PATH}/internal/linux.zsh"
  ;;
esac

core::ensure curl

# Auto-install herdr if missing
if ! core::exists herdr; then
    herdr::internal::install
fi
