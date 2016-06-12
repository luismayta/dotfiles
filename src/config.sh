#!/usr/bin/env bash
# -*- coding: utf-8 -*-

export APP_NAME='.dotfiles'
export GIT_URI='https://github.com/luismayta/dotfiles.git'
export GIT_BRANCH='master'
export DEBUG_MODE='0'
export PATH_REPO="$HOME/$APP_NAME"
export PATH_BACKUP="$HOME/backup"
export PATH_PYENV="$HOME/.pyenv"
export PATH_GVM="$HOME/.gvm"
export PATH_WAKATIME="$HOME/.wakatime"

export PATH_GIT_EXTRAS="$HOME/.gvm"
export PATH_RVM="$HOME/.rvm"
export PATH_NVM="$HOME/.nvm"
export PATH_TPM="$HOME/.tmux/plugins/tpm"
export PATH_THEMEPACK="$HOME/.tmux-themepack"
export PATH_SCM_BREEZE="$HOME/.scm_breeze"
export PATH_FONTS_REPO="$PATH_REPO/resources/fonts"

export FILE_SETTINGS_OSX="$SRC_DIR/settings/osx.sh"
export FILE_SETTINGS_LINUX="$SRC_DIR/settings/linux.sh"

export URL_WAKATIME_BASH="https://raw.githubusercontent.com/API-PLUGIN-RESSOURCES/bash-wakatime/master/bash-wakatime.sh"
export NAME_WAKATIME_BASH=".wakatime.sh"

if [[ `uname` == 'Darwin' ]]; then
	[ -r "$FILE_SETTINGS_OSX" ] && source "$FILE_SETTINGS_OSX"
else
	[ -r "$FILE_SETTINGS_LINUX" ] && source "$FILE_SETTINGS_LINUX"
fi
