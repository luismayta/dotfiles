# shellcheck shell=bash
#
# Configuration variables for the nvim module.

# Module root path (set by plugin.zsh as ZSH_NVIM_PATH)
: "${NVIM_PATH:=${ZSH_NVIM_PATH:-}}"

# Neovim configuration path
: "${NVIM_CONFIG_PATH:=${HOME}/.config/nvim}"

# Package name (binary)
: "${NVIM_PACKAGE_NAME:=nvim}"

# Root path for neovim configuration
: "${NVIM_ROOT_PATH:=${HOME}/.config/nvim}"

# Neovim file settings path (used by editnvim)
: "${NVIM_FILE_SETTINGS:=${NVIM_CONFIG_PATH}/lua/config/options.lua}"


