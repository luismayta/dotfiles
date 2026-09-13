# shellcheck shell=bash
ZSH_HERDR_ENABLED="${ZSH_HERDR_ENABLED:-true}"

# Canonical names
export ZSH_HERDR_PACKAGE_NAME=herdr
export ZSH_HERDR_INSTALL_URL="https://herdr.dev/install.sh"
export ZSH_HERDR_CONFIG_PATH="${HOME}/.config/herdr"
export ZSH_HERDR_DATA_PATH="${ZSH_HERDR_PATH}/data"

# Workspace management
export ZSH_HERDR_WORKSPACE_PREFIX="${ZSH_HERDR_WORKSPACE_PREFIX:-}"

# Project template path
export ZSH_HERDR_PROJECT_TEMPLATE_PATH="${ZSH_HERDR_DATA_PATH}/plugins/config/cloudmanic.herdr-plus/projects"

# Plugin management
# Add plugins via ZSH_HERDR_INSTALL_PLUGINS+=("owner/repo") in your .zshrc
# shellcheck disable=SC2034 # used externally by internal/base.zsh
typeset -ga ZSH_HERDR_INSTALL_PLUGINS
export ZSH_HERDR_PLUGIN_ENABLED="${ZSH_HERDR_PLUGIN_ENABLED:-true}"

# Custom CLI dependencies — installed per-OS via internal/{osx,linux}.zsh
# Each entry maps to herdr::internal::deps::install::<binary>
typeset -ga ZSH_HERDR_CUSTOM_DEPS
ZSH_HERDR_CUSTOM_DEPS+=("espresso")

# Espresso CLI (macOS-only, required by herdr-espresso plugin)
export ZSH_HERDR_ESPRESSO_INSTALL_URL="https://raw.githubusercontent.com/Hanyang-Li/espresso/main/install.sh"
export ZSH_HERDR_ESPRESSO_ENABLED="${ZSH_HERDR_ESPRESSO_ENABLED:-true}"

# Backward-compatible aliases (temporary — for existing shell sessions)
export HERDR_PACKAGE_NAME="${ZSH_HERDR_PACKAGE_NAME}"
export HERDR_INSTALL_URL="${ZSH_HERDR_INSTALL_URL}"
export HERDR_WORKSPACE_PREFIX="${ZSH_HERDR_WORKSPACE_PREFIX}"
export ZSH_HRD_PROJECT_TEMPLATE_PATH="${ZSH_HERDR_PROJECT_TEMPLATE_PATH}"
export ZSH_HRD_PLUGIN_ENABLED="${ZSH_HERDR_PLUGIN_ENABLED}"