# shellcheck shell=bash
# shellcheck source=/dev/null
source "${WEZTERM_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${WEZTERM_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${WEZTERM_PATH}/internal/linux.zsh"
  ;;
esac

if ! core::exists rsync; then core::install rsync; fi

if ! core::exists wezterm; then
    wezterm::internal::install
fi
