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

# Helix root path
: "${ZSH_HELIX_ROOT_PATH:=${ZSH_HELIX_CONFIG_PATH:-}}"

# Helix data home (XDG)
: "${ZSH_HELIX_DATA_HOME:=${HOME}/.local/share/helix}"

# Helix cache home (XDG)
: "${ZSH_HELIX_CACHE_HOME:=${HOME}/.cache/helix}"

# Helix state home (XDG)
: "${ZSH_HELIX_STATE_HOME:=${HOME}/.local/state/helix}"
