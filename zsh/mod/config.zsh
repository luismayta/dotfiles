#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

export BACKUP_DIR="${HOME}/.backup"
export PRIVATERC="${HOME}/.privaterc"
export CUSTOMRC="${HOME}/.customrc"
export LOCAL_PATH_BIN="${HOME}/.local/bin"

export PATH="${DOTFILES_BIN}:${PATH}"

[ ! -e "${BACKUP_DIR}" ] && mkdir -p "${BACKUP_DIR}"

# language
export LANG="en_US.UTF-8"
export LC_ALL=$LANG

export GIT_INTERNAL_GETTEXT_TEST_FALLBACKS=1

# Fix for autosuggest when copy-pasting, it prints super slow on long
# Buffers (pastes)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=15
export ZSH_AUTOSUGGEST_USE_ASYNC=true

# History
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=5000 # maximum number of in-memory history
export SAVEHIST=5000 # maximum number of records in $HISTFILE

[ -e "${LOCAL_PATH_BIN}" ] && export PATH="${LOCAL_PATH_BIN}:${PATH}"
[ -e "${HOME}/local/bin" ] && export PATH="${HOME}/local/bin:${PATH}"

[ -e "/usr/local/sbin" ] && export PATH="/usr/local/sbin:${PATH}"
[ -e "/usr/local/opt/qt/bin" ] && export PATH="/usr/local/opt/qt/bin:${PATH}"
