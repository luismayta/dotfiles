#!/usr/bin/env bash
# -*- coding: utf-8 -*-

############################  SETUP PARAMETERS
APP_NAME='.dotfiles'
GIT_URI='https://github.com/luismayta/dotfiles.git'
GIT_BRANCH='develop'
DEBUG_MODE='0'
PATH_REPO="${HOME}/${APP_NAME}"

msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [[ "$ret" -eq '0' ]]; then
        msg "\e[32m[✔]\e[0m ${1}${2}"
    fi
}

error() {
    msg "\e[31m[✘]\e[0m ${1}${2}"
    exit 1
}

debug() {
    if [ "$DEBUG_MODE" -eq '1' ] && [ "$ret" -gt '1' ]; then
      msg "An error occured in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

clone_repo() {
    if [[ ! -e "${PATH_REPO}/.git" ]]; then
        git clone --recursive -b "$GIT_BRANCH" "$GIT_URI" "$PATH_REPO"
        ret="$?"
        success "$1"
        debug
    else
        upgrade_repo "$APP_NAME" "Successfully updated $APP_NAME"
    fi

    if [[ "$ret" -eq '0' ]] && [[ ! $TRAVIS = 'true' ]]; then
        cd "${PATH_REPO}" || exit
        make run
    fi
}

############################  BASIC SETUP TOOLS
program_exists() {
    local app=$1
    local message="Need to install $app."
    local ret='0'
    type "$1" >> /dev/null 2>&1 || { local ret='1'; }

    # throw error on non-zero return value
    if [[ ! "$ret" -eq '0' ]]; then
        error "$message"
        exit
    fi
}

function upgrade_repo() {
    msg "trying to update $1"

    if [ "$1" = "${APP_NAME}" ]; then
        cd "$PATH_REPO" || exit
        git pull origin "${GIT_BRANCH}"
    fi

    ret="$?"
    success "$2"
    debug
}

# Mac Stuff -------------------------------------------------------------------
if [[ $(uname) == 'Darwin' ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install zsh git go rsync \
         # Utils -----------------------------------------------------------------------
         jq ag fd ripgrep cmake ctags \
             bash
fi

# Archlinux Stuff
if type -p pacman > /dev/null; then
    packages=(
        git
        go
        npm
        yarn
        gcc
        rsync
    )
    for package in "${packages[@]}"; do
        sudo pacman -S --noconfirm "${package}"
    done
    npm install -g n
fi

for app in {zsh,git,rsync}; do
    program_exists "$app"
done
unset app

clone_repo      "Successfully cloned ${APP_NAME}"

msg             "\nThanks for installing ${APP_NAME}."
msg             "© $(date +%Y) ${APP_NAME}"
