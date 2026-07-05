# shellcheck shell=bash
ZSH_HERDR_ENABLED="${ZSH_HERDR_ENABLED:-true}"

export HERDR_PACKAGE_NAME=herdr
export HERDR_INSTALL_URL="https://herdr.dev/install.sh"
export HERDR_CONFIG_PATH="${HOME}/.config/herdr"
export ZSH_HERDR_DATA_PATH="${ZSH_HERDR_PATH}/data"
