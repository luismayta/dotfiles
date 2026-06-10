#
# Core ZSH module
#
# Port of hadenlabs/zsh-core into the modules/ convention.
# Provides env vars, package auto-install, messaging, fzf helpers,
# Docker wrappers, eza aliases, Linux helpers, git utils, and backup.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_CORE_LOADED:-}" ]] && return
__ZSH_CORE_LOADED=1

# Module root path — used by all sourced sub-files
CORE_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${CORE_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${CORE_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${CORE_PATH}/pkg/main.zsh"
