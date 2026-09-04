# shellcheck shell=bash
# shellcheck disable=SC1091
#
# Plugin main entry point.
# helix module - Helix editor configuration and package management
#
# Auto-discovery: this file is sourced by zsh/zshrc via directory iteration.

# Guard: prevent multiple sources
if [[ -n "${__ZSH_HELIX_LOADED:-}" ]]; then
  return 0
fi
readonly __ZSH_HELIX_LOADED=1

# Get the module root directory
# shellcheck disable=SC2296,SC2298
: "${ZSH_HELIX_PATH:="${${(%):-%x}:A:h}"}"

message_info "Loading module: helix"

# Source layers in order: config → internal → pkg
source "${ZSH_HELIX_PATH}/config/main.zsh"
$ZSH_HELIX_ENABLED || return
source "${ZSH_HELIX_PATH}/internal/main.zsh"
source "${ZSH_HELIX_PATH}/pkg/main.zsh"

# Auto-sync guards (must be after pkg/main.zsh so helix::sync exists)
if ! core::exists rsync; then core::install rsync; fi
if ! core::exists "${ZSH_HELIX_PACKAGE_NAME}"; then core::install "${ZSH_HELIX_PACKAGE_NAME}"; fi
if [[ ! -d "${ZSH_HELIX_CONFIG_PATH}" ]]; then helix::sync; fi