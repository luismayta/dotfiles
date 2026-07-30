# shellcheck shell=bash
# Global sync orchestration — dotfiles::sync
#
# Entry point for running all module ::sync functions in order,
# respecting ZSH_<MODULE>_ENABLED flags.

# shellcheck disable=SC2034
typeset -ga DOTFILES_SYNC_MODULES
DOTFILES_SYNC_MODULES=(
  core
  ghostty alacritty wezterm zed hammerspoon
  starship tmux herdr
  git ssh nvim nix ai
  devops hyprland resources
  devbox
)

function core::sync {
  rsync -avzh --progress "${CORE_PATH}/data/." "${HOME}/"
}

function dotfiles::sync {
  _dotfiles::run_modules DOTFILES_SYNC_MODULES "sync" "sync"
}
