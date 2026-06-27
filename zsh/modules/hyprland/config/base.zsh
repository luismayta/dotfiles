# shellcheck shell=bash
ZSH_HYPRLAND_ENABLED="${ZSH_HYPRLAND_ENABLED:-true}"
export HYPRLAND_PACKAGE_NAME=hyprland
export HOME_CONFIG_PATH="${HOME}"/.config
export HYPRLAND_FILE_SETTINGS="${HOME_CONFIG_PATH}/hypr/hyprland.lua"
export HYPRLAND_CONFIG_PATH="${HOME_CONFIG_PATH}/hypr"