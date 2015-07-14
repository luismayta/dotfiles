#!/usr/bin/env bash

############################  SETUP PARAMETERS
APP_NAME='.dotfiles'
GIT_URI='https://github.com/luismayta/dotfiles.git'
GIT_BRANCH='master'
DEBUG_MODE='0'
PATH_REPO="$HOME/$APP_NAME"
PATH_BACKUP="$HOME/backup"
FILES_FONTS="$PATH_REPO/resources/fonts/*"

msg() {
    printf '%b\n' "$1" >&2
}

function success() {
    if [ "$ret" -eq '0' ]; then
        msg "\e[32m[✔]\e[0m ${1}${2}"
    fi
}

function error() {
    msg "\e[31m[✘]\e[0m ${1}${2}"
    exit 1
}

function debug() {
    if [ "$DEBUG_MODE" -eq '1' ] && [ "$ret" -gt '1' ]; then
      msg "An error occured in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

############################  BASIC SETUP TOOLS
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

function clone_repo() {
    if [ ! -e "$PATH_REPO/.git" ]; then
        git clone --recursive -b "$GIT_BRANCH" "$GIT_URI" "$PATH_REPO"
        ret="$?"
        success "$1"
        debug
    else
        upgrade_repo "$APP_NAME" "Successfully updated $APP_NAME"
    fi

    if [ "$ret" -eq '0' ]; then
        "$PATH_REPO/bootstrap.sh"
    fi
}

for app in {zsh,git,tmux}; do
    program_exists "$app"
done
unset app

clone_repo      "Successfully cloned $app_name"

msg             "\nThanks for installing $app_name."
msg             "© `date +%Y` $app_name"
