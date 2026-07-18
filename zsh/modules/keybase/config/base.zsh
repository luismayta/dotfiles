# shellcheck shell=bash

ZSH_KEYBASE_ENABLED="${ZSH_KEYBASE_ENABLED:-true}"

export ZSH_KEYBASE_PACKAGE_NAME=keybase
export ZSH_KEYBASE_INSTALL_URL_LINUX="https://keybase.io/docs/the_app/install_linux"
export ZSH_KEYBASE_CONFIG_PATH="${HOME}/.config/keybase"
export ZSH_KEYBASE_DATA_PATH="${ZSH_KEYBASE_PATH}/data"
