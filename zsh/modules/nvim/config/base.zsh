# shellcheck shell=bash
#
# Configuration variables for the nvim module.

# Neovim repository URL for configuration
: "${NVIM_REPO_HTTPS:=luismayta/nvimrc}"
export NVIM_INSTALL_URL="https://github.com/luismayta/nvimrc.git"

# Neovim configuration path
: "${NVIM_CONFIG_PATH:=${HOME}/.config/nvim}"

# Package name (binary)
: "${NVIM_PACKAGE_NAME:=nvim}"

# Root path for neovim configuration
: "${NVIM_ROOT_PATH:=${HOME}/.config/nvim}"


