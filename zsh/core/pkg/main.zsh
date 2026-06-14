#
# shellcheck shell=bash
# Pkg main — sources all package modules
#

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/pkg/base.zsh

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${DOTFILES_CORE_PATH}"/pkg/osx.zsh
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${DOTFILES_CORE_PATH}"/pkg/linux.zsh
  ;;
esac

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/pkg/helper/main.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/pkg/alias.zsh
