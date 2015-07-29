#!/usr/bin/env bash
# -*- coding: utf-8 -*-

function die () {
    echo "${@}"
    exit 1
}

function program_exists() {
    local $app=$1
    local message="Need to install $app."
    local ret='0'
    type $1 >/dev/null 2>&1 || { local ret='1'; }

    # throw error on non-zero return value
    if [ ! "$ret" -eq '0' ]; then
        error "$message"
        exit
    fi
}

function do_backup() {
    local ret='0'
    local message="Your old dotfiles stuff has a suffix now and looks like"
    local today=`date +%Y%m%d`
    local path_today="$PATH_BACKUP/$today/"
    `mkdir -p "$path_today"`
    local file_backup="$path_today${file##*/}"

    if [ -r "$1" ]; then
        mv "$1" "$file_backup";
        ret="$?"
        success "$message $file_backup"
        debug
    fi
}

function cp_file() {
    local ret='0'
    local message="Your move file "

    if [ -r "$1" ]; then
        cp "$1" "$2";
        ret="$?"
        success "$message $1 to $2"
        debug
    fi
}
