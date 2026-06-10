# shellcheck source=/dev/null
# shellcheck shell=bash
source "${GHOSTTY_PATH}/pkg/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${GHOSTTY_PATH}/pkg/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${GHOSTTY_PATH}/pkg/linux.zsh"
  ;;
esac

# shellcheck source=/dev/null
source "${GHOSTTY_PATH}/pkg/helper.zsh"

# shellcheck source=/dev/null
source "${GHOSTTY_PATH}/pkg/alias.zsh"

# Auto-install Ghostty if not present
if ! core::exists ghostty; then
    ghostty::install
fi
