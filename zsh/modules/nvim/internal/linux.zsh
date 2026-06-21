# shellcheck shell=bash
#
# Linux-specific internal logic for nvim module.
# Sets XDG base directories for nvim data, cache, and state.

export NVIM_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/nvim"
export NVIM_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}/nvim"
export NVIM_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}/nvim"
