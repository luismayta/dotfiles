# shellcheck shell=bash
# Ollama configuration variables

export ZSH_AI_OLLAMA_MODELS_PATH="${HOME}/.ollama/models"
export ZSH_AI_INSTALL_URL_OLLAMA="https://ollama.com/install.sh"

export ZSH_AI_OLLAMA_MODELS=(
  deepseek-coder:6.7b
  qwen2.5-coder:7b
  codellama:13
)
