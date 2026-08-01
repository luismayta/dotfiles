# shellcheck shell=bash

# Antidote - plugin manager configuration

export ZSH_ANTIDOTE_ENABLED="${ZSH_ANTIDOTE_ENABLED:-true}"

# Runtime install path (convention _PATH, backward compat)
export ANTIDOTE_PATH="${ANTIDOTE_PATH:-${ZDOTDIR:-${HOME}}/.antidote}"

# Plugin bundle sources
export ANTIDOTE_PLUGINS_FILE="${DOTFILES_ZSH_PATH}/zsh_plugins.txt"
export ANTIDOTE_CUSTOM_PLUGINS_FILE="${HOME}/.custom_zsh_plugins.txt"
export ANTIDOTE_BUNDLE_FILE="${HOME}/.zsh_plugins.txt"
