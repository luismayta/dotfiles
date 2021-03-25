#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function dotfiles::config::main::factory {
    # shellcheck source=/dev/null
    source "${MOD_DIR}"/config/base.zsh
    case "${OSTYPE}" in
    darwin*)
        # shellcheck source=/dev/null
        source "${MOD_DIR}"/config/osx.zsh
        ;;
    linux*)
        # shellcheck source=/dev/null
        source "${MOD_DIR}"/config/linux.zsh
      ;;
    esac
}

dotfiles::config::main::factory
