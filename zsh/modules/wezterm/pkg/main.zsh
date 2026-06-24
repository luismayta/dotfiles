# shellcheck shell=bash
# shellcheck source=/dev/null
source "${WEZTERM_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${WEZTERM_PATH}/pkg/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${WEZTERM_PATH}/pkg/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${WEZTERM_PATH}/pkg/helper.zsh"

# shellcheck source=/dev/null
source "${WEZTERM_PATH}/pkg/alias.zsh"

# Auto-install wezterm if not present
if ! core::exists wezterm; then
    wezterm::install
fi
