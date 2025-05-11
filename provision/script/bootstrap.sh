#!/usr/bin/env bash
# -*- coding: utf-8 -*-

export HOME=~
export PROJECT_NAME=dotfiles
export PYENV_NAME="${PROJECT_NAME}"

# Vars Dir application
export ROOT_DIR
ROOT_DIR=$(pwd)
export EXTRAS_DIR="${ROOT_DIR}/provision"
export PATH_REPO="${HOME}/.${PROJECT_NAME}"
export SCRIPT_DIR="${PATH_REPO}/provision/script"
export CONF_DIR="${PATH_REPO}/conf"
export ZSH_DIR="${PATH_REPO}/zsh"
export TOOLS_DIR="${PATH_REPO}/tools"
export PATH_BACKUP="${HOME}/backup"

export PATH_FONTS_REPO="${PATH_REPO}/provision/fonts"

export FILE_CONFIG_BASE="${SCRIPT_DIR}/config/base.sh"
export FILE_CONFIG_OSX="${SCRIPT_DIR}/config/osx.sh"
export FILE_CONFIG_LINUX="${SCRIPT_DIR}/config/linux.sh"

export LOCAL_PATH_BIN="${HOME}/.local/bin"

mkdir -p "${LOCAL_PATH_BIN}"

# shellcheck source=/dev/null
[ -r "${FILE_CONFIG_BASE}" ] && source "${FILE_CONFIG_BASE}"

function detect::os {
    uname
}

function config::factory {
    local os_name
    os_name=$(detect::os)
    case "$os_name" in
        "Darwin")
            # shellcheck source=/dev/null
            [ -r "${FILE_CONFIG_OSX}" ] && source "${FILE_CONFIG_OSX}"
            ;;
        "Linux")
            # shellcheck source=/dev/null
            [ -r "${FILE_CONFIG_LINUX}" ] && source "${FILE_CONFIG_LINUX}"
            setup::linux
            ;;
        *)
            echo "Unsupported OS: $os_name"
            exit 1
            ;;
    esac
}

config::factory

for file in "${SCRIPT_DIR}/"{config,messages,repo,functions}.sh; do
    # shellcheck source=/dev/null
    [ -e "${file}" ] && source "${file}"
done
unset file