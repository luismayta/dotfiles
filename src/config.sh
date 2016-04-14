#!/usr/bin/env bash
# -*- coding: utf-8 -*-

APP_NAME='.dotfiles'
GIT_URI='https://github.com/luismayta/dotfiles.git'
GIT_BRANCH='master'
DEBUG_MODE='0'
PATH_REPO="$HOME/$APP_NAME"
PATH_BACKUP="$HOME/backup"
PATH_PYENV="$HOME/.pyenv"
PATH_GVM="$HOME/.gvm"

PATH_GIT_EXTRAS="$HOME/.gvm"
PATH_RVM="$HOME/.rvm"
PATH_NVM="$HOME/.nvm"
PATH_TPM="$HOME/.tmux/plugins/tpm"
PATH_THEMEPACK="$HOME/.tmux-themepack"
PATH_SCM_BREEZE="$HOME/.scm_breeze"
# PATH_ANTIGEN="$HOME/.antigen"
# FILE_ANTIGEN="$HOME/.antigen/antigen.zsh"
PATH_ANTIBODY="$HOME/.antibody"
FILE_ANTIBODY="$HOME/.antibody/antibody.zsh"
PATH_FONTS_REPO="$PATH_REPO/resources/fonts"

FILE_SETTINGS_OSX="$SRC_DIR/settings/osx.sh"
FILE_SETTINGS_LINUX="$SRC_DIR/settings/linux.sh"

if [[ `uname` == 'Darwin' ]]; then
	[ -r "$FILE_SETTINGS_OSX" ] && source "$FILE_SETTINGS_OSX"
else
	[ -r "$FILE_SETTINGS_LINUX" ] && source "$FILE_SETTINGS_LINUX"
fi
