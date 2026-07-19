# shellcheck shell=bash

# shellcheck source=/dev/null
source "${ZSH_MPD_PATH}"/internal/base.zsh

case "${OSTYPE}" in
  darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_MPD_PATH}"/internal/osx.zsh
    ;;
  linux*)
    # shellcheck source=/dev/null
    source "${ZSH_MPD_PATH}"/internal/linux.zsh
    ;;
esac

if ! core::exists mpd; then mpd::internal::install; fi

# Load (start service) if binary exists
if core::exists mpd; then
  mpd::internal::load
fi