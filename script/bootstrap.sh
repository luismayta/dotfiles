#!/usr/bin/env bash
# -*- coding: utf-8 -*-

export HOME=~
export PROJECT_NAME=dotfiles
export PYTHON_VERSION=2.7.9
export PYENV_NAME="${PROJECT_NAME}"

export GRIP_PORT=6430

# Vars Dir application
export ROOT_DIR
ROOT_DIR=$(pwd)
export RESOURCES_DIR="${ROOT_DIR}/resources"
export RESOURCES_DB_DIR="${RESOURCES_DIR}/db"
export REQUIREMENTS_DIR="${ROOT_DIR}/requirements"
export PATH_REPO="${HOME}/.${PROJECT_NAME}"
export SCRIPT_DIR="${PATH_REPO}/script"
export CONF_DIR="${PATH_REPO}/conf"
export TOOLS_DIR="${PATH_REPO}/tools"

export GIT_URI='https://github.com/luismayta/dotfiles.git'
export GIT_BRANCH='master'
export DEBUG_MODE='0'
export PATH_BACKUP="$HOME/backup"
export PATH_PYENV="$HOME/.pyenv"
export PATH_GVM="$HOME/.gvm"

export PATH_GIT_EXTRAS="$HOME/.gvm"
export PATH_RVM="$HOME/.rvm"
export PATH_NVM="$HOME/.nvm"
export PATH_TPM="$HOME/.tmux/plugins/tpm"
export PATH_SCM_BREEZE="$HOME/.scm_breeze"
export PATH_FONTS_REPO="$PATH_REPO/resources/fonts"

export FILE_SETTINGS_OSX="${SCRIPT_DIR}/settings/osx.sh"
export FILE_SETTINGS_LINUX="${SCRIPT_DIR}/settings/linux.sh"

export URL_WAKATIME_BASH="https://raw.githubusercontent.com/API-PLUGIN-RESSOURCES/bash-wakatime/master/bash-wakatime.sh"

for file in "${SCRIPT_DIR}/"{config,messages,repo,functions}.sh; do
    # shellcheck source=/dev/null
    [ -e "${file}" ] && source "${file}"
done
unset file
