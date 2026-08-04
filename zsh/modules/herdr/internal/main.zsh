# shellcheck shell=bash
# shellcheck source=/dev/null

# Sourcing order respects dependencies:
#   base (utilities) → install → update → workspace → worktree → pane
source "${ZSH_HERDR_PATH}/internal/base.zsh"
source "${ZSH_HERDR_PATH}/internal/install.zsh"
source "${ZSH_HERDR_PATH}/internal/update.zsh"
source "${ZSH_HERDR_PATH}/internal/workspace.zsh"
source "${ZSH_HERDR_PATH}/internal/worktree.zsh"
source "${ZSH_HERDR_PATH}/internal/pane.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_HERDR_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_HERDR_PATH}/internal/linux.zsh"
  ;;
esac

core::ensure curl

# Auto-install herdr if missing
if ! core::exists herdr; then
    herdr::internal::install
fi