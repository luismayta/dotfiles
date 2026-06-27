# shellcheck shell=bash
ZSH_ZED_ENABLED="${ZSH_ZED_ENABLED:-true}"

export ZED_PACKAGE_NAME=zed
export ZED_INSTALL_URL="https://zed.dev/install.sh"
export ZED_CONFIG_PATH="${HOME}/.config/zed"
export ZED_SETTINGS_FILE="settings.json"
export ZED_KEYMAP_FILE="keymap.json"
export ZSH_ZED_DATA_PATH="${ZSH_ZED_PATH}/data"