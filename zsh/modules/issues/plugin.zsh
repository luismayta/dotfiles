# shellcheck shell=bash
# Issues ZSH module
#
# Port of hadenlabs/zsh-issues into the modules/ convention.
# Provides issue creation, PR management, and provider abstraction
# (GitHub/GitLab) with git workflow detection.
#
# This is the only file the zshrc sources — it internally chains:
#   config/main.zsh → internal/main.zsh → provider/main.zsh →
#   workflow/main.zsh → pkg/main.zsh
#

# Idempotency guard
[[ -n "${__ZSH_ISSUES_LOADED:-}" ]] && return
__ZSH_ISSUES_LOADED=1

# Module root path
ISSUES_PATH="$(dirname "${0}")"

# shellcheck source=/dev/null
source "${ISSUES_PATH}/config/main.zsh"

# shellcheck source=/dev/null
source "${ISSUES_PATH}/internal/main.zsh"

# shellcheck source=/dev/null
source "${ISSUES_PATH}/provider/main.zsh"

# shellcheck source=/dev/null
source "${ISSUES_PATH}/workflow/main.zsh"

# shellcheck source=/dev/null
source "${ISSUES_PATH}/pkg/main.zsh"

# chpwd hook for provider re-detection
if [[ -z "${chpwd_functions[*]}" ]]; then
    chpwd_functions=()
fi
if ! (( ${chpwd_functions[(Ie)issues::provider::factory]} )); then
    chpwd_functions+=(issues::provider::factory)
fi
