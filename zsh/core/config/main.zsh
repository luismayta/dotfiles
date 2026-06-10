# shellcheck shell=bash

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/config/paths.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/config/history.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/config/language.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/config/autosuggest.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/config/git.zsh

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${DOTFILES_CORE_DIR}"/config/osx.zsh
    ;;
linux*)
    # shellcheck source=/dev/null
    source "${DOTFILES_CORE_DIR}"/config/linux.zsh
  ;;
esac

[ ! -e "${DOTFILES_BACKUP_DIR}" ] && mkdir -p "${DOTFILES_BACKUP_DIR}"
[ ! -e "${DOTFILES_CACHE_DIR}" ] && mkdir -p "${DOTFILES_CACHE_DIR}"
