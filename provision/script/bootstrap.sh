#!/usr/bin/env bash
# -*- coding: utf-8 -*-

export PROJECT_NAME=dotfiles
export PYENV_NAME="${PROJECT_NAME}"

# Vars Dir application
export ROOT_PATH
ROOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
export PATH_REPO="${HOME}/.${PROJECT_NAME}"
export SCRIPT_PATH="${PATH_REPO}/provision/script"
export ZSH_PATH="${PATH_REPO}/zsh"
export PATH_BACKUP="${HOME}/backup"

export PATH_FONTS_REPO="${PATH_REPO}/provision/fonts"

export FILE_CONFIG_BASE="${SCRIPT_PATH}/config/base.sh"
export FILE_CONFIG_OSX="${SCRIPT_PATH}/config/osx.sh"
export FILE_CONFIG_LINUX="${SCRIPT_PATH}/config/linux.sh"

export LOCAL_PATH_BIN="${HOME}/.local/bin"

mkdir -p "${LOCAL_PATH_BIN}"

[ -r "${FILE_CONFIG_BASE}" ] || { echo "FATAL: ${FILE_CONFIG_BASE} not found" >&2; exit 1; }
# shellcheck disable=SC1090
source "${FILE_CONFIG_BASE}"

[ -r "${ROOT_PATH}/common/colors.sh" ] || { echo "FATAL: lib/colors.sh not found" >&2; exit 1; }
# shellcheck source=/dev/null
source "${ROOT_PATH}/common/colors.sh"

[ -r "${ROOT_PATH}/common/messages.sh" ] || { echo "FATAL: lib/messages.sh not found" >&2; exit 1; }
# shellcheck source=/dev/null
source "${ROOT_PATH}/common/messages.sh"

[ -r "${ROOT_PATH}/common/common.sh" ] || { echo "FATAL: lib/common.sh not found" >&2; exit 1; }
# shellcheck source=/dev/null
source "${ROOT_PATH}/common/common.sh"

function config::factory {
    local os_name
    os_name=$(detect::os)
    case "$os_name" in
        "Darwin")
            [ -r "${FILE_CONFIG_OSX}" ] || { echo "FATAL: ${FILE_CONFIG_OSX} not found" >&2; exit 1; }
            # shellcheck disable=SC1090
            source "${FILE_CONFIG_OSX}"
            ;;
        "Linux")
            [ -r "${FILE_CONFIG_LINUX}" ] || { echo "FATAL: ${FILE_CONFIG_LINUX} not found" >&2; exit 1; }
            # shellcheck disable=SC1090
            source "${FILE_CONFIG_LINUX}"
            ;;
        *)
            echo "Unsupported OS: $os_name"
            exit 1
            ;;
    esac
}

config::factory

file="${SCRIPT_PATH}/functions.sh"
[ -r "${file}" ] || { echo "FATAL: ${file} not found" >&2; exit 1; }
# shellcheck disable=SC1090
source "${file}"
unset file
