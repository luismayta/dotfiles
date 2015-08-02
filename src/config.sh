#!/usr/bin/env bash
# -*- coding: utf-8 -*-

if [[ `uname` == 'Darwin' ]]; then
    # MacOS
    FONTS_DIR="$HOME/Library/Fonts"
else
    # Linux
    FONTS_DIR="$HOME/.fonts"
    mkdir -p $FONTS_DIR
fi

APP_NAME='.dotfiles'
GIT_URI='https://github.com/luismayta/dotfiles.git'
GIT_BRANCH='master'
DEBUG_MODE='0'
PATH_REPO="$HOME/$APP_NAME"
PATH_BACKUP="$HOME/backup"
PATH_PYENV="$HOME/.pyenv"
PATH_GVM="$HOME/.gvm"
PATH_RVM="$HOME/.rvm"
PATH_NVM="$HOME/.nvm"
PATH_TPM="$HOME/.tmux/plugins/tpm"
PATH_THEMEPACK="$HOME/.tmux-themepack"
PATH_ANTIGEN="$HOME/.antigen"
FILE_ANTIGEN="$HOME/.antigen/antigen.zsh"
PATH_FONTS_REPO="$PATH_REPO/resources/fonts"
