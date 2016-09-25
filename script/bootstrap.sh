#!/usr/bin/env bash
# -*- coding: utf-8 -*-

HOME=~
PROJECT_NAME=dotfiles
PYTHON_VERSION=2.7.9
PYENV_NAME="${PROJECT_NAME}"

GVM_NAME="${PROJECT_NAME}"
GVM_PATHS_NAME="{src, pkg, bin}"

# Vars Dir
ROOT_DIR=$(pwd)
RESOURCES_DIR="${ROOT_DIR}/resources"
RESOURCES_DB_DIR="${RESOURCES_DIR}/db"
APP_DIR="${HOME}/.${PROJECT_NAME}"
SRC_DIR="${APP_DIR}/src"
CONF_DIR="${APP_DIR}/conf"
TOOLS_DIR="${APP_DIR}/tools"

for file in "$SRC_DIR/"{config.sh,messages.sh,repo.sh,functions.sh}; do
    [ -r "${file}" ] && source "${file}"
done
unset file