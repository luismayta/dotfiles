# shellcheck shell=bash

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/internal/path.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/internal/editor.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/internal/backup.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/internal/reload.zsh

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${DOTFILES_CORE_DIR}"/internal/osx.zsh
    ;;
linux*)
    # shellcheck source=/dev/null
    source "${DOTFILES_CORE_DIR}"/internal/linux.zsh
  ;;
esac
