# shellcheck shell=bash
# shellcheck source=/dev/null
source "${TMUX_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${TMUX_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${TMUX_PATH}/internal/linux.zsh"
  ;;
esac


