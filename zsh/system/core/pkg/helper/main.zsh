#
# shellcheck shell=bash
# Helper main — sources core.zsh and backup.zsh
#

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/pkg/helper/backup.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/pkg/helper/core.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_PATH}"/pkg/helper/tmux.zsh
