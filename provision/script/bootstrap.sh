#!/usr/bin/env bash
# -*- coding: utf-8 -*-

export HOME=~
export PROJECT_NAME=dotfiles
export PYENV_NAME="${PROJECT_NAME}"

export GRIP_PORT=6430

# Vars Dir application
export ROOT_DIR
ROOT_DIR=$(pwd)
export EXTRAS_DIR="${ROOT_DIR}/provision"
export PATH_REPO="${HOME}/.${PROJECT_NAME}"
export SCRIPT_DIR="${PATH_REPO}/provision/script"
export CONF_DIR="${PATH_REPO}/conf"
export TOOLS_DIR="${PATH_REPO}/tools"

export GIT_URI='https://github.com/luismayta/dotfiles.git'
export GIT_BRANCH='master'
export DEBUG_MODE='0'
export PATH_BACKUP="${HOME}/backup"

export PATH_SCM_BREEZE="$HOME/.scm_breeze"
export PATH_FONTS_REPO="${PATH_REPO}/provision/fonts"

export FILE_SETTINGS_OSX="${SCRIPT_DIR}/settings/osx.sh"
export FILE_SETTINGS_LINUX="${SCRIPT_DIR}/settings/linux.sh"

export URL_WAKATIME_BASH="https://raw.githubusercontent.com/API-PLUGIN-RESSOURCES/bash-wakatime/master/bash-wakatime.sh"

for file in "${SCRIPT_DIR}/"{config,messages,repo,functions}.sh; do
    # shellcheck source=/dev/null
    [ -e "${file}" ] && source "${file}"
done
unset file
