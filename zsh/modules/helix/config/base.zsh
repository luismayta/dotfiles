# shellcheck shell=bash
ZSH_HELIX_ENABLED="${ZSH_HELIX_ENABLED:-true}"
#
# Configuration variables for the helix module.

# Module root path (set by plugin.zsh as ZSH_HELIX_PATH)
: "${ZSH_HELIX_PATH:=${ZSH_HELIX_PATH:-}}"

# Package name (binary)
: "${ZSH_HELIX_PACKAGE_NAME:=helix}"

# Helix configuration path
: "${ZSH_HELIX_CONFIG_PATH:=${HOME}/.config/helix}"

# Helix data path (module data directory)
: "${ZSH_HELIX_DATA_PATH:=${ZSH_HELIX_PATH}/data}"
