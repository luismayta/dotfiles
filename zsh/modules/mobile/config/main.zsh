# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_MOBILE_PATH}/config/base.zsh"
source "${ZSH_MOBILE_PATH}/config/android.zsh"
source "${ZSH_MOBILE_PATH}/config/flutter.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_MOBILE_PATH}/config/osx.zsh" ;;
linux*)
  source "${ZSH_MOBILE_PATH}/config/linux.zsh" ;;
esac
