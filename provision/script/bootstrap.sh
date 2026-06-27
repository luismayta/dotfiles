#!/usr/bin/env bash
# -*- coding: utf-8 -*-

export PROJECT_NAME=dotfiles
export PYENV_NAME="${PROJECT_NAME}"

# Vars Dir application
export ROOT_DIR
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
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

[ -r "${FILE_CONFIG_BASE}" ] || { echo "FATAL: ${FILE_CONFIG_BASE} not found" >&2; exit 1; }
# shellcheck disable=SC1090
source "${FILE_CONFIG_BASE}"

# shellcheck source=/dev/null
[ -r "${ROOT_DIR}/common/colors.sh" ] || { echo "FATAL: lib/colors.sh not found" >&2; exit 1; }
source "${ROOT_DIR}/common/colors.sh"

# shellcheck source=/dev/null
[ -r "${ROOT_DIR}/common/messages.sh" ] || { echo "FATAL: lib/messages.sh not found" >&2; exit 1; }
source "${ROOT_DIR}/common/messages.sh"

# shellcheck source=/dev/null
[ -r "${ROOT_DIR}/common/common.sh" ] || { echo "FATAL: lib/common.sh not found" >&2; exit 1; }
source "${ROOT_DIR}/common/common.sh"

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

file="${SCRIPT_DIR}/functions.sh"
[ -r "${file}" ] || { echo "FATAL: ${file} not found" >&2; exit 1; }
# shellcheck disable=SC1090
source "${file}"
unset file
