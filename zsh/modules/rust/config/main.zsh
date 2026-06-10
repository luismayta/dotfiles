# shellcheck shell=bash
case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${RUST_PATH}/config/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${RUST_PATH}/config/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${RUST_PATH}/config/base.zsh"
