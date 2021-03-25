#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function dotfiles::internal::main::factory {
    # shellcheck source=/dev/null
    source "${ZSH_DOTFILES_PATH}"/internal/base.zsh

    # shellcheck source=/dev/null
    source "${ZSH_DOTFILES_PATH}"/internal/aliases.zsh

    case "${OSTYPE}" in
    darwin*)
        # shellcheck source=/dev/null
        source "${ZSH_DOTFILES_PATH}"/internal/osx.zsh
        ;;
    linux*)
        # shellcheck source=/dev/null
        source "${ZSH_DOTFILES_PATH}"/internal/linux.zsh
      ;;
    esac
}

dotfiles::internal::main::factory
