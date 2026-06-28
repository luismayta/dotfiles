# shellcheck shell=bash
# Global sync orchestration — dotfiles::sync
#
# Entry point for running all module ::sync functions in order,
# respecting ZSH_<MODULE>_ENABLED flags.

# shellcheck disable=SC2034
typeset -ga DOTFILES_SYNC_MODULES
DOTFILES_SYNC_MODULES=(
  ghostty alacritty wezterm zed
  starship tmux
  git ssh nvim ai
  devops hyprland resources
  devbox
)

function dotfiles::sync {
  _dotfiles::run_modules DOTFILES_SYNC_MODULES "sync" "sync"
}
