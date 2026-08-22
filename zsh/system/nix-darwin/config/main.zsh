# shellcheck shell=bash
source "${NIX_DARWIN_PATH}/config/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${NIX_DARWIN_PATH}/config/osx.zsh" ;;
linux*)
  # shellcheck source=/dev/null
  source "${NIX_DARWIN_PATH}/config/linux.zsh" ;;
esac
