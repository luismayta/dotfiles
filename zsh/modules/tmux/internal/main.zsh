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

if ! core::exists rsync; then core::install rsync; fi
if ! core::exists fzf; then core::install fzf; fi
if ! core::exists tmux; then tmux::internal::tmux::install; fi
[ -e "${TMUX_TPM_PATH}" ] || tmux::internal::tpm::install
