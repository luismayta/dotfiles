# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_ZED_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_ZED_PATH}/internal/osx.zsh" ;;
linux*)
  source "${ZSH_ZED_PATH}/internal/linux.zsh" ;;
esac

# shellcheck source=/dev/null
source "${ZSH_ZED_PATH}/internal/helper.zsh"

core::ensure curl

if ! core::exists zed; then zed::internal::install; fi