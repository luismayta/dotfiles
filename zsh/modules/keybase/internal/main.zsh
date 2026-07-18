# shellcheck shell=bash
source "${ZSH_KEYBASE_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  source "${ZSH_KEYBASE_PATH}/internal/osx.zsh" ;;
linux*)
  source "${ZSH_KEYBASE_PATH}/internal/linux.zsh" ;;
esac

core::ensure curl

if ! core::exists keybase; then
    keybase::internal::install
fi
