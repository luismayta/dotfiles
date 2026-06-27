# shellcheck shell=bash
ZSH_NVIM_ENABLED="${ZSH_NVIM_ENABLED:-true}"
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
: "${NVIM_FILE_SETTINGS:=${NVIM_CONFIG_PATH}/lua/options.lua}"

# XDG base directories for data, cache, and state
# (overridden on Linux by config/linux.zsh to use XDG_*_HOME)
: "${NVIM_DATA_HOME:=${HOME}/.local/share/nvim}"
: "${NVIM_CACHE_HOME:=${HOME}/.cache/nvim}"
: "${NVIM_STATE_HOME:=${HOME}/.local/state/nvim}"


