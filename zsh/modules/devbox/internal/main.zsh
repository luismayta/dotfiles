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

if ! core::nix::exists; then
    message_warning "Nix is not installed. Install it with 'nix::install' or https://nixos.org/download"
fi
if ! core::exists devbox; then devbox::internal::install; fi
