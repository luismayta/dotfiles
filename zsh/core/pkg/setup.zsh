# shellcheck shell=bash
# Global setup orchestration — dotfiles::setup
#
# Entry point for running all module ::setup functions in order,
# respecting ZSH_<MODULE>_ENABLED flags.

# shellcheck disable=SC2034
typeset -ga DOTFILES_SETUP_MODULES
DOTFILES_SETUP_MODULES=(
  wezterm zed hammerspoon mobile
  git issues nodejs
)

function dotfiles::setup {
  _dotfiles::run_modules DOTFILES_SETUP_MODULES "setup" "setup"
}
