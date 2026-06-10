# shellcheck shell=bash

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/internal/base.zsh"

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_GIT_PATH}/internal/osx.zsh"
    ;;
linux*)
    # shellcheck source=/dev/null
    source "${ZSH_GIT_PATH}/internal/linux.zsh"
    ;;
esac

# Export bin directory to PATH
export PATH="${ZSH_GIT_PATH}/bin:${PATH}"

# Ensure core dependencies are installed
if ! core::exists git; then core::install git; fi
if ! core::exists hub; then core::install hub; fi
if ! core::exists rsync; then core::install rsync; fi
if ! core::exists git-flow; then core::install git-flow; fi
