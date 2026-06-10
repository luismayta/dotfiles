#
# shellcheck shell=bash
# Helper main — sources core.zsh and backup.zsh
#

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/pkg/helper/backup.zsh

# shellcheck source=/dev/null
source "${DOTFILES_CORE_DIR}"/pkg/helper/core.zsh
