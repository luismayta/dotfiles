# shellcheck shell=bash

# shellcheck source=/dev/null
source "${ZSH_GHQ_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_GHQ_PATH}/internal/osx.zsh"
    ;;
linux*)
    # shellcheck source=/dev/null
    source "${ZSH_GHQ_PATH}/internal/linux.zsh"
    ;;
esac

core::ensure rsync
core::ensure "${ZSH_GHQ_PACKAGE_NAME}"
if ! core::exists cookiecutter; then ghq::internal::cookiecutter::install; fi
