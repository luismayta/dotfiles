# shellcheck shell=bash

# --- Domain files (dependency order) ---
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/base.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/tools.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/opencode.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/fabric.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/ollama.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/skills.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/openspec.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/graphify.zsh"

# --- Tool files (split from tools.zsh) ---
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/shimmy.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/openclaw.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/codegraph.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/rtk.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/hunk.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/pi.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/hf.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/tmuxai.zsh"
# shellcheck source=/dev/null
source "${ZSH_AI_PATH}/internal/jcode.zsh"

# --- OS-specific ---
case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_AI_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_AI_PATH}/internal/linux.zsh"
  ;;
esac

# --- Load paths ---
ai::internal::opencode::load
ai::internal::shimmy::load
ai::internal::openclaw::load
ai::internal::codegraph::load
ai::internal::rtk::load
ai::internal::hunk::load
ai::internal::pi::load
ai::internal::graphify::load
ai::internal::openspec::load
ai::internal::skills::load
ai::internal::jcode::load
