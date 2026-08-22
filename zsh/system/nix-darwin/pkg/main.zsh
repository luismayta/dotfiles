# shellcheck shell=bash
source "${NIX_DARWIN_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${NIX_DARWIN_PATH}/pkg/osx.zsh" ;;
linux*)
  # shellcheck source=/dev/null
  source "${NIX_DARWIN_PATH}/pkg/linux.zsh" ;;
esac

# shellcheck source=/dev/null
source "${NIX_DARWIN_PATH}/pkg/helper.zsh"
# shellcheck source=/dev/null
source "${NIX_DARWIN_PATH}/pkg/alias.zsh"
