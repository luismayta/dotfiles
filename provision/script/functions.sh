#!/usr/bin/env bash
# -*- coding: utf-8 -*-

function initialize() {
    for app in {zsh,git,rsync}; do
        program_exists "$app"
    done
    unset app

    dotfiles_install_factory

    for path in "${CONF_DIR}"/{shell,app}; do
        for file_path in "${path}/"*; do
            local file
            file="${HOME}/.${file_path##*/}"
            do_backup "${file}"
            cp_file "$file_path" "$file"
            unset file
        done
        unset file_path
    done
    unset path

    cp_file "${ZSH_DIR}/zshrc" "${HOME}/.zshrc"
    cp_file "${ZSH_DIR}/zshenv" "${HOME}/.zshenv"

    rsync -avzh --progress "${CONF_DIR}/.config/" "${HOME}/.config/"
    rsync -avzh --progress "${CONF_DIR}/Library/" "${HOME}/Library/"
}

function die() {
    echo "${@}"
    exit 1
}

function is_program_exist() {
    if ! type -p "${1}" > /dev/null; then
        echo 1
        exit 1
    fi
    echo 0
}

function program_exists() {
    local app=$1
    local message="Need to install $app."
    local ret='0'
    type -p "${1}" >> /dev/null 2>&1 || { local ret='1'; }

    # throw error on non-zero return value
    if [[ ! "$ret" -eq '0' ]]; then
        error "$message"
        exit
    fi
}

function do_backup() {
    local ret='0'
    local message="Your old dotfiles stuff has a suffix now and looks like"
    local today
    today=$(date +%Y%m%d)
    local path_today="${PATH_BACKUP}/${today}/"
    mkdir -p "${path_today}"
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

function dotfiles_install_factory {
    if type -p pacman > /dev/null; then
        # shellcheck source=/dev/null
        source "${HOME}/.dotfiles"/archlinux.sh
    fi
    dotfiles_install_apps
}

function dotfiles_install_apps() {
    for app in "${APPS[@]}"; do
        "${TOOLS_DIR}/${app}/install.sh"
    done
    unset app
}

function replace_files(){
    echo -n "This may overwrite existing files in your home directory. Are you sure? (y/n) "

    read -r response

    if [[ $response =~ ^[Yy]$ ]]; then
        initialize
    fi
}