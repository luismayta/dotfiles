# shellcheck shell=bash
ZSH_DEVBOX_ENABLED="${ZSH_DEVBOX_ENABLED:-true}"

export DEVBOX_PACKAGE_NAME="devbox"
export DEVBOX_DATA_PATH="${ZSH_DEVBOX_PATH}/data"
export DEVBOX_GLOBAL_CONFIG_PATH="${HOME}/.config/devbox"
