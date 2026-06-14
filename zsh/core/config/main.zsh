# shellcheck shell=bash

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/config/env.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/config/paths.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/config/history.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/config/language.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/config/autosuggest.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/config/git.zsh

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${DOTFILES_CORE_PATH}"/config/osx.zsh
    ;;
linux*)
    # shellcheck source=/dev/null
    source "${DOTFILES_CORE_PATH}"/config/linux.zsh
  ;;
esac

[ ! -e "${DOTFILES_BACKUP_PATH}" ] && mkdir -p "${DOTFILES_BACKUP_PATH}"
[ ! -e "${DOTFILES_CACHE_PATH}" ] && mkdir -p "${DOTFILES_CACHE_PATH}"
