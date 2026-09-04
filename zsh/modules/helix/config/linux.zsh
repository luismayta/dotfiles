# shellcheck shell=bash
#
# Linux-specific configuration overrides for helix module.
# XDG path overrides for Linux.

export ZSH_HELIX_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/helix"
export ZSH_HELIX_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}/helix"
export ZSH_HELIX_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}/helix"
