# shellcheck shell=bash
# AI ZSH module
#
# Provides AI tool installation (opencode, fabric, ollama, shimmy, hf, openclaw, tmuxai),
# config synchronization, and helper commands for managing AI tooling.
#
# Ported from hadenlabs/zsh-ai into the modules/ convention.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_AI_LOADED:-}" ]] && return
__ZSH_AI_LOADED=1

# Module root path — used by all sourced sub-files
AI_PATH="$(dirname "${0}")"

message_info "Loading module: ai"

# shellcheck source=/dev/null
source "${AI_PATH}/config/main.zsh"
$ZSH_AI_ENABLED || return

# shellcheck source=/dev/null
source "${AI_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${AI_PATH}/pkg/main.zsh"

# Auto-install guards (must be after pkg/main.zsh so ai::install exists)
if ! core::exists rsync; then core::install rsync; fi
if ! core::exists fzf; then core::install fzf; fi
