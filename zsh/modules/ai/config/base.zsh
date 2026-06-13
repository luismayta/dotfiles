# shellcheck shell=bash

ARCH_NAME="$(uname -m)"
export ARCH_NAME

export AI_PACKAGE_NAME=ai

# opencode
export AI_OPENCODE_ROOT_PATH="${HOME}/.opencode"
export AI_OPENCODE_BIN_PATH="${AI_OPENCODE_ROOT_PATH}/bin"
export AI_OPENCODE_CONFIG_PATH="${HOME}/.config/opencode"
export AI_OPENCODE_CONFIG_FILE="opencode.json"
export AI_OPENCODE_CONFIG_SOURCE_PATH="${AI_PATH}/data/opencode"
export AI_OPENCODE_RUNTIME_SOURCE_PATH="${AI_PATH}/.opencode"
export AI_OPENCODE_RUNTIME_CONFIG_PATH="${AI_OPENCODE_CONFIG_PATH}/.opencode"
export AI_OPENCODE_CONFIG_FILE_PATH="${AI_OPENCODE_CONFIG_PATH}/${AI_OPENCODE_CONFIG_FILE}"

# fabric
export AI_FABRIC_PATTERNS_PATH="${HOME}/.config/fabric/patterns"
export AI_FABRIC_PATTERNS_SYNC_SOURCE="${AI_PATH}/data/patterns"

# ollama
export AI_OLLAMA_MODELS_PATH="${HOME}/.ollama/models"

# shimmy
export AI_SHIMMY_BIN_PATH="${HOME}/.local/bin"

# openclaw
export AI_OPENCLAW_BIN_PATH="${HOME}/.local/bin"

# codegraph
export AI_CODEGRAPH_BIN_PATH="${HOME}/.local/bin"

# installation urls
export AI_INSTALL_URL_OPENCODE="https://opencode.ai/install"
export AI_INSTALL_URL_FABRIC="https://raw.githubusercontent.com/danielmiessler/fabric/main/scripts/installer/install.sh"
export AI_INSTALL_URL_OLLAMA="https://ollama.com/install.sh"
export AI_INSTALL_URL_SHIMMY="https://github.com/Michael-A-Kuykendall/shimmy/releases/latest/download"
export AI_INSTALL_URL_HF="https://hf.co/cli/install.sh"
export AI_INSTALL_URL_OPENCLAW="https://openclaw.ai/install.sh"
export AI_INSTALL_URL_CODEGRAPH="https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh"
export AI_INSTALL_URL_TMUXAI="https://get.tmuxai.dev"

export AI_TOOLS=(
  opencode
  fabric
  ollama
  shimmy
  hf
  openclaw
  codegraph
  tmuxai
)

export AI_OLLAMA_MODELS=(
  deepseek-coder:6.7b
  qwen2.5-coder:7b
  codellama:13
)
