# shellcheck shell=bash

# --- Base ---
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/base.zsh"

# --- Domain files ---
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/opencode.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/fabric.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/ollama.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/skills.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/openspec.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/graphify.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/hunk.zsh"

# --- Tool files (split from tools.zsh) ---
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/shimmy.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/hf.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/openclaw.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/codegraph.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/tmuxai.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/rtk.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/pi.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/jcode.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/archify.zsh"

# --- OS-specific ---
case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_AI_PATH}/pkg/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_AI_PATH}/pkg/linux.zsh"
  ;;
esac

# --- Alias ---
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/pkg/alias.zsh"
