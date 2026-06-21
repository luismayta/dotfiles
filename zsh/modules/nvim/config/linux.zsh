# shellcheck shell=bash
#
# Linux-specific configuration overrides for nvim module.
# Uses XDG base directory specification.

export NVIM_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/nvim"
export NVIM_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}/nvim"
export NVIM_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}/nvim"
