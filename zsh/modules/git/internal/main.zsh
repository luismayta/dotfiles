# shellcheck shell=bash

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/internal/base.zsh"

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/internal/get-module-path.zsh"

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/internal/delta.zsh"

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
core::path::prepend "${ZSH_GIT_PATH}/bin"

# Ensure core dependencies are installed
core::ensure git
core::ensure hub
core::ensure rsync

# Ensure scmpuff is installed and initialize it
core::ensure scmpuff
scmpuff::internal::load

# Ensure delta is installed and apply its git config
git::internal::delta::install
git::internal::delta::load