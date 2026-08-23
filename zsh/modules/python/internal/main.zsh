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

core::ensure curl
python::internal::uv::load
