# shellcheck shell=bash
# shellcheck source=/dev/null
source "${ZSH_RVM_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
  # shellcheck source=/dev/null
  source "${ZSH_RVM_PATH}/internal/osx.zsh"
  ;;
linux*)
  # shellcheck source=/dev/null
  source "${ZSH_RVM_PATH}/internal/linux.zsh"
  ;;
esac

if ! core::exists curl; then core::ensure curl; fi
if ! core::exists gpg; then core::ensure gpg; fi
rvm::internal::rvm::load
if ! core::exists rvm; then rvm::internal::rvm::install; fi
