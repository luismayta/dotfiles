# shellcheck shell=bash
#
# AI module configuration — thin dispatcher.
# Domain-specific variables live in their own files (opencode.zsh, fabric.zsh, etc.).
# This file only contains cross-cutting concerns shared across multiple domains.

ZSH_AI_ENABLED="${ZSH_AI_ENABLED:-true}"

ARCH_NAME="$(uname -m)"
export ARCH_NAME

export ZSH_AI_PACKAGE_NAME=ai

# --- Domain configs (dependency order: tools first, then specific domains) ---
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/shimmy.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/openclaw.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/codegraph.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/rtk.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/hunk.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/pi.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/hf.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/tmuxai.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/opencode.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/fabric.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/ollama.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/graphify.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/openspec.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/config/skills.zsh"

# --- Tool registry (used by internal/tools.zsh::packages::install) ---
export ZSH_AI_TOOLS=(
  opencode
  fabric
  ollama
  shimmy
  hf
  openclaw
  codegraph
  graphify
  tmuxai
  hunk
  rtk
  pi
  skills
)
