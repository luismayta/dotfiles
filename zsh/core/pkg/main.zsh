#
# shellcheck shell=bash
# Pkg main — sources all package modules
#

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/pkg/base.zsh

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${DOTFILES_CORE_DIR}"/pkg/osx.zsh
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${DOTFILES_CORE_DIR}"/pkg/linux.zsh
  ;;
esac

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/pkg/helper/main.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/pkg/docker.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/pkg/alias.zsh
