# shellcheck shell=bash
#
# AI module configuration — thin dispatcher.
# Domain-specific variables live in their own files (opencode.zsh, fabric.zsh, etc.).
# This file only contains cross-cutting concerns shared across multiple domains.

ZSH_AI_ENABLED="${ZSH_AI_ENABLED:-true}"

ARCH_NAME="$(uname -m)"
export ARCH_NAME

export AI_PACKAGE_NAME=ai

# --- Domain configs (dependency order: tools first, then specific domains) ---
# shellcheck source=/dev/null
source "${AI_PATH}/config/tools.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/config/opencode.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/config/fabric.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/config/ollama.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/config/graphify.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/config/openspec.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/config/skills.zsh"

# --- Installation URLs (used by internal/tools.zsh for installs) ---
export AI_INSTALL_URL_OPENCODE="https://opencode.ai/install"
export AI_INSTALL_URL_FABRIC="https://raw.githubusercontent.com/danielmiessler/fabric/main/scripts/installer/install.sh"
export AI_INSTALL_URL_OLLAMA="https://ollama.com/install.sh"
export AI_INSTALL_URL_SHIMMY="https://github.com/Michael-A-Kuykendall/shimmy/releases/latest/download"
export AI_INSTALL_URL_HF="https://hf.co/cli/install.sh"
export AI_INSTALL_URL_OPENCLAW="https://openclaw.ai/install.sh"
export AI_INSTALL_URL_CODEGRAPH="https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh"
export AI_INSTALL_URL_TMUXAI="https://get.tmuxai.dev"
export AI_INSTALL_URL_RTK="https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh"
export AI_INSTALL_URL_HUNK="npm i -g hunkdiff"
export AI_INSTALL_URL_PI="https://pi.dev/install.sh"
export AI_INSTALL_URL_SKILLS="https://raw.githubusercontent.com/vercel-labs/skills/main/install.sh"

# --- Tool registry (used by internal/tools.zsh::packages::install) ---
export AI_TOOLS=(
  opencode
  fabric
  ollama
  shimmy
  hf
  openclaw
  codegraph
  tmuxai
  hunk
  rtk
  pi
  skills
)

# --- Ollama models (used by internal/ollama.zsh) ---
export AI_OLLAMA_MODELS=(
  deepseek-coder:6.7b
  qwen2.5-coder:7b
  codellama:13
)
