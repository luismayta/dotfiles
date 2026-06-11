# shellcheck shell=bash

export DOTFILES_BACKUP_DIR="${HOME}/.backup"
export DOTFILES_CACHE_DIR="${HOME}/.cache/dotfiles"
export LOCAL_PATH_BIN="${HOME}/.local/bin"
export HOMEBREW_BIN_PATH="/opt/homebrew/bin"
export PRIVATERC="${HOME}/.privaterc"
export CUSTOMRC="${HOME}/.customrc"
export DOTFILES_CORE_DIR="${DOTFILES_ZSH_DIR}/core"
export DOTFILES_MOD_DIR="${DOTFILES_CORE_DIR}"

export PATH="${DOTFILES_BIN}:${PATH}"

[ -e "${LOCAL_PATH_BIN}" ] && export PATH="${LOCAL_PATH_BIN}:${PATH}"
[ -e "${HOME}/local/bin" ] && export PATH="${HOME}/local/bin:${PATH}"
[ -e "/usr/local/sbin" ] && export PATH="/usr/local/sbin:${PATH}"
[ -e "/usr/local/opt/qt/bin" ] && export PATH="/usr/local/opt/qt/bin:${PATH}"
