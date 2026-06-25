# shellcheck source=/dev/null
# shellcheck shell=bash
source "${ALACRITTY_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ALACRITTY_PATH}/pkg/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ALACRITTY_PATH}/pkg/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${ALACRITTY_PATH}/pkg/helper.zsh"

# shellcheck source=/dev/null
source "${ALACRITTY_PATH}/pkg/alias.zsh"

# Auto-install Alacritty if not present
if ! core::exists alacritty; then
    alacritty::install
fi
