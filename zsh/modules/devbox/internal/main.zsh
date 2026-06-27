# shellcheck shell=bash

# shellcheck source=/dev/null
source "${ZSH_DEVBOX_PATH}"/internal/base.zsh

case "${OSTYPE}" in
  darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_DEVBOX_PATH}"/internal/osx.zsh
    ;;
  linux*)
    # shellcheck source=/dev/null
    source "${ZSH_DEVBOX_PATH}"/internal/linux.zsh
    ;;
esac

core::nix::ensure
if ! core::exists devbox; then devbox::internal::install; fi
