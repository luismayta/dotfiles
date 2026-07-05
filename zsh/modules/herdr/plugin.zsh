# shellcheck shell=bash
# HERDR ZSH module
#
# Provides HERDR (HadenLabs Environment Runtime for Development) tool
# installation, config synchronization, and management.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_HERDR_LOADED:-}" ]] && return
__ZSH_HERDR_LOADED=1

# Module root path — used by all sourced sub-files
ZSH_HERDR_PATH="$(dirname "${0}")"

message_info "Loading module: ${ZSH_HERDR_PACKAGE_NAME:-herdr}"

# shellcheck source=/dev/null
source "${ZSH_HERDR_PATH}/config/main.zsh"
${ZSH_HERDR_ENABLED:-false} || return

# shellcheck source=/dev/null
source "${ZSH_HERDR_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ZSH_HERDR_PATH}/pkg/main.zsh"

# Auto-install guards (must be after pkg/main.zsh so functions exist)
if ! core::exists rsync; then core::install rsync; fi
if ! core::exists fzf; then core::install fzf; fi
