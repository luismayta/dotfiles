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

# create cache and reload settings
function reload {
    exec "${SHELL}" -l
}

# default keybind
bindkey -e

# notification
setopt nobeep # no beep sound

# dir
setopt nonomatch # no glob expansion for *, ?, [ and ]
setopt auto_cd   # cd without cd
setopt autopushd # push dir automatically
setopt pushd_ignore_dups # do not push duplicated dir
setopt correct   # spelling correction for commands
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# History
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=100000 # maximum number of in-memory history
export SAVEHIST=100000 # maximum number of records in $HISTFILE
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

select-history() {
    BUFFER=$(fc -l -n 1 | tail -r | awk '!a[$0]++' | fzy -l $(tput lines) --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N select-history # register as widget
bindkey '^h' select-history # assign key bind
