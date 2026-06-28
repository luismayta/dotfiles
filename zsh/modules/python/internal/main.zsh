# shellcheck shell=bash

# shellcheck source=/dev/null
source "${ZSH_PYENV_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_PYENV_PATH}/internal/osx.zsh"
    ;;
linux*)
    # shellcheck source=/dev/null
    source "${ZSH_PYENV_PATH}/internal/linux.zsh"
    ;;
esac

pyenv::internal::pyenv::load

core::ensure curl
for pkg in "${PYENV_SYSTEM_PACKAGES[@]}"; do
    core::ensure "${pkg}"
done
if ! core::exists pyenv; then pyenv::internal::pyenv::install; fi
