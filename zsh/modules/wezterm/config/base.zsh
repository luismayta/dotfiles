# shellcheck shell=bash
ZSH_WEZTERM_ENABLED="${ZSH_WEZTERM_ENABLED:-true}"
export WEZTERM_PACKAGE_NAME=wezterm
export WEZTERM_CONFIG_PATH="${HOME}/.config/wezterm"
export ZSH_WEZTERM_DATA_PATH="${WEZTERM_PATH}/data"
