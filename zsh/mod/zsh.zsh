#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

antibody bundle zsh-users/zsh-syntax-highlighting

autoload -Uz add-zsh-hook # enable zsh hooks

function editrc {
    if [ -z "${1}" ]; then
        "${EDITOR}" "${HOME}"/.zshrc
        return
    fi
    "${EDITOR}" "${MOD_DIR}"/"${1}".zsh
}

# create cache and reload settings
function reload {
    exec "${SHELL}" -l
}

function editprivaterc {
    if [ -z "${PRIVATERC}" ]; then
        message_info "not exist file privaterc"
        return
    fi
    "${EDITOR}" "${PRIVATERC}"
}

function editcustomrc {
    if [ -z "${CUSTOMRC}" ]; then
        message_info "not exist file customrc"
        return
    fi
    "${EDITOR}" "${CUSTOMRC}"
}


# History
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=5000 # maximum number of in-memory history
export SAVEHIST=5000 # maximum number of records in $HISTFILE
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
