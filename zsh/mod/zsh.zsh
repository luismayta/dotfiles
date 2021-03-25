#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

function editrc {
    if [ -z "${1}" ]; then
        "${EDITOR}" "${HOME}"/.zshrc
        return
    fi
    "${EDITOR}" "${MOD_DIR}"/"${1}".zsh
}

# create cache and reload settings
function reload {
    exec "${SHELL}"
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

function backup {
    local today path_today file_backup
    if [ -z "${BACKUP_DIR}" ]; then
        message_info "not exist path ~/.backup"
        return
    fi
    if [ -z "${1}" ] || [ ! -r "${1}" ]; then
        message_info "is it neccessary file"
        return
    fi

    today=$(date +%Y%m%d)
    path_today="${BACKUP_DIR}/${today}"
    mkdir -p "${path_today}"
    file_backup="${path_today}/${1##*/}"
    cp -rf "${1}" "$file_backup"
}

# History
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=5000 # maximum number of in-memory history
export SAVEHIST=5000 # maximum number of records in $HISTFILE
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
