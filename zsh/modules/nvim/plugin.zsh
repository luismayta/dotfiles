# shellcheck shell=bash
# shellcheck disable=SC1091
#
# Plugin main entry point.
# nvim module - neovim configuration and package management
#
# Auto-discovery: this file is sourced by zsh/zshrc via directory iteration.

# Guard: prevent multiple sources
if [[ -n "${__ZSH_NVIM_LOADED:-}" ]]; then
  return 0
fi
readonly __ZSH_NVIM_LOADED=1

# Get the module root directory
# shellcheck disable=SC2296,SC2298
: "${ZSH_NVIM_PATH:="${${(%):-%x}:A:h}"}"

message_info "Loading module: nvim"

# Source layers in order: config → internal → pkg
source "${ZSH_NVIM_PATH}/config/main.zsh"
source "${ZSH_NVIM_PATH}/internal/main.zsh"
source "${ZSH_NVIM_PATH}/pkg/main.zsh"

# Auto-sync guards (must be after pkg/main.zsh so nvim::sync exists)
if ! core::exists rsync; then core::install rsync; fi
if ! core::exists nvim; then core::install nvim; fi
if [[ ! -d "${NVIM_CONFIG_PATH}" ]]; then nvim::sync; fi
