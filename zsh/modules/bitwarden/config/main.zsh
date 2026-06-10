# shellcheck shell=bash
case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${BITWARDEN_PATH}/config/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${BITWARDEN_PATH}/config/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${BITWARDEN_PATH}/config/base.zsh"
