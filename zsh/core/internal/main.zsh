# shellcheck shell=bash

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/internal/path.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/internal/editor.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/internal/backup.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/internal/api.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/internal/nix.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/internal/reload.zsh

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${DOTFILES_CORE_PATH}"/internal/osx.zsh
    ;;
linux*)
    # shellcheck source=/dev/null
    source "${DOTFILES_CORE_PATH}"/internal/linux.zsh
  ;;
esac
