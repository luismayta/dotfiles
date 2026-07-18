# shellcheck shell=bash

# --- Base ---
# shellcheck source=/dev/null
source "${AI_PATH}/pkg/base.zsh"

# --- Domain files ---
# shellcheck source=/dev/null
source "${AI_PATH}/pkg/opencode.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/pkg/fabric.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/pkg/ollama.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/pkg/skills.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/pkg/openspec.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/pkg/graphify.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/pkg/hunk.zsh"
# shellcheck source=/dev/null
source "${AI_PATH}/pkg/tools.zsh"

# --- OS-specific ---
case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${AI_PATH}/pkg/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${AI_PATH}/pkg/linux.zsh"
  ;;
esac

# --- Alias ---
# shellcheck source=/dev/null
source "${AI_PATH}/pkg/alias.zsh"
