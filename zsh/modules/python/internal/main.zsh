# shellcheck shell=bash

# shellcheck source=/dev/null
source "${ZSH_PYTHON_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_PYTHON_PATH}/internal/osx.zsh"
    ;;
linux*)
    # shellcheck source=/dev/null
    source "${ZSH_PYTHON_PATH}/internal/linux.zsh"
    ;;
esac

python::internal::pyenv::load

core::ensure curl
if [[ "${PYTHON_UV_ENABLED}" == "true" ]]; then
    core::ensure uv
fi
if ! core::exists pyenv; then python::internal::pyenv::install; fi
