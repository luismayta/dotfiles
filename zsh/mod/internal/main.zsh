#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function dotfiles::internal::main::factory {
    # shellcheck source=/dev/null
    source "${DOTFILES_MOD_DIR}"/internal/base.zsh

    # shellcheck source=/dev/null
    source "${DOTFILES_MOD_DIR}"/internal/aliases.zsh

    case "${OSTYPE}" in
    darwin*)
        # shellcheck source=/dev/null
        source "${DOTFILES_MOD_DIR}"/internal/osx.zsh
        ;;
    linux*)
        # shellcheck source=/dev/null
        source "${DOTFILES_MOD_DIR}"/internal/linux.zsh
      ;;
    esac
}

dotfiles::internal::main::factory
