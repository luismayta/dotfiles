# shellcheck shell=bash
ZSH_HERDR_ENABLED="${ZSH_HERDR_ENABLED:-true}"

export HERDR_PACKAGE_NAME=herdr
export HERDR_INSTALL_URL="https://herdr.dev/install.sh"
export HERDR_CONFIG_PATH="${HOME}/.config/herdr"
export ZSH_HERDR_DATA_PATH="${ZSH_HERDR_PATH}/data/conf"

# Workspace management
export HERDR_WORKSPACE_PREFIX="${HERDR_WORKSPACE_PREFIX:-}"

# Project template path
export ZSH_HRD_PROJECT_TEMPLATE_PATH="${ZSH_HERDR_DATA_PATH}/plugins/config/cloudmanic.herdr-plus/projects"
