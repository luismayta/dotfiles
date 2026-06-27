# shellcheck shell=bash

# shellcheck source=/dev/null
source "${ZSH_NIX_PATH}"/pkg/base.zsh

case "${OSTYPE}" in
  darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_NIX_PATH}"/pkg/osx.zsh
    ;;
  linux*)
    # shellcheck source=/dev/null
    source "${ZSH_NIX_PATH}"/pkg/linux.zsh
    ;;
esac

# shellcheck source=/dev/null
source "${ZSH_NIX_PATH}"/pkg/alias.zsh

# shellcheck source=/dev/null
source "${ZSH_NIX_PATH}"/pkg/helper.zsh

# shellcheck source=/dev/null
source "${ZSH_NIX_PATH}"/pkg/scaffold.zsh
