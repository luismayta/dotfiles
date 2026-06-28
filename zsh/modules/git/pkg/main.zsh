# shellcheck shell=bash

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/pkg/base.zsh"

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/pkg/setup.zsh"

case "${OSTYPE}" in
darwin*)
    # shellcheck source=/dev/null
    source "${ZSH_GIT_PATH}/pkg/osx.zsh"
    ;;
linux*)
    # shellcheck source=/dev/null
    source "${ZSH_GIT_PATH}/pkg/linux.zsh"
    ;;
esac

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/pkg/alias.zsh"

# shellcheck source=/dev/null
source "${ZSH_GIT_PATH}/pkg/fzf.zsh"

# Auto-initialize git config and check dependencies
git::pkg::config::setup
git::dependences::check
