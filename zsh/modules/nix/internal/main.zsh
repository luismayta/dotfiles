# shellcheck shell=bash

# shellcheck source=/dev/null
source "${ZSH_NIX_PATH}"/internal/base.zsh

case "${OSTYPE}" in
  darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_NIX_PATH}"/internal/osx.zsh
    ;;
  linux*)
    # shellcheck source=/dev/null
    source "${ZSH_NIX_PATH}"/internal/linux.zsh
    ;;
esac

# Ensure Nix is available
nix::internal::nix::install
