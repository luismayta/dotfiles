#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

autoload -Uz add-zsh-hook # enable zsh hooks

function editrc {
    if [[ -z "${1}" ]]; then
        vim "${HOME}"/.zshrc
    else
        vim "${MOD_DIR}"/"${1}".zsh
    fi
}

# History
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=100000 # maximum number of in-memory history
export SAVEHIST=100000 # maximum number of records in $HISTFILE
