# shellcheck shell=bash
# shellcheck source=/dev/null
source "${RUST_PATH}/internal/base.zsh"

# shellcheck source=/dev/null
source "${RUST_PATH}/internal/packages.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${RUST_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${RUST_PATH}/internal/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${RUST_PATH}/internal/helper.zsh"
