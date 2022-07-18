#!/usr/bin/env bash
# -*- coding: utf-8 -*-

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;36m"
NORMAL="\033[0m"

DOTFILES_NAME='.dotfiles'
DOTFILES_GIT_URI='https://github.com/luismayta/dotfiles.git'
DOTFILES_GIT_BRANCH='Develop'
PATH_REPO="${HOME}/${APP_NAME}"

function message::info {
    printf "${BLUE}%s${NORMAL}\n" "[INFO]: ${1}"
}

function message::warning {
    printf "${YELLOW}%s${NORMAL}\n" "[WARNING]: ${1}"
}

function message::success {
    printf "${GREEN}%s${NORMAL}\n" "🧉 [SUCCESS]: ${1}"
}

function message::error {
    printf "${RED}%s${NORMAL}\n" "😈 [ERROR]: ${1}"
}

function message::debug {
    printf "${YELLOW}%s${NORMAL}\n" "😈 [DEBUG]: ${1}"
}

clone_repo() {
    if [[ ! -e "${PATH_REPO}/.git" ]]; then
        git clone --recursive -b "$GIT_BRANCH" "$GIT_URI" "$PATH_REPO"
        ret="$?"
        message::success "$1"
        message::debug
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
    type -p "$1" >> /dev/null 2>&1 || { local ret='1'; }

    # throw error on non-zero return value
    if [[ ! "$ret" -eq '0' ]]; then
        message::error "${message}"
        exit
    fi
}

function upgrade_repo() {
    message::info "trying to update $1"

    if [ "$1" = "${APP_NAME}" ]; then
        cd "$PATH_REPO" || exit
        git pull origin "${GIT_BRANCH}"
    fi

    ret="$?"
    message::success "${2}"
    message::debug
}

# Mac Stuff -------------------------------------------------------------------
if [[ $(uname) == 'Darwin' ]]; then
    if ! type -p brew > /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install zsh git rsync \
         jq ag fd ripgrep cmake ksh
    zsh --login
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

message::info             "\nThanks for installing ${APP_NAME}."
message::info             "© $(date +%Y) ${APP_NAME}"
