# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_WAYBAR_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_WAYBAR_PATH}/internal/osx.zsh" ;;
linux*)
  source "${ZSH_WAYBAR_PATH}/internal/linux.zsh" ;;
esac

# shellcheck source=/dev/null
source "${ZSH_WAYBAR_PATH}/internal/helper.zsh"

core::ensure rsync

if ! core::exists waybar; then waybar::internal::install; fi
