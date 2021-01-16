#!/usr/bin/env bash
# -*- coding: utf-8 -*-

############################  SETUP PARAMETERS
app_name='.dotfiles'
git_uri='https://github.com/luismayta/dotfiles.git'
git_branch='master'
debug_mode='0'
fork_maintainer='0'
path_repo="$HOME/$app_name"

msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" -eq '0' ]; then
    msg "\e[32m[✔]\e[0m ${1}${2}"
    fi
}

error() {
    msg "\e[31m[✘]\e[0m ${1}${2}"
    exit 1
}

debug() {
    if [ "$debug_mode" -eq '1' ] && [ "$ret" -gt '1' ]; then
      msg "An error occured in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

############################  BASIC SETUP TOOLS
program_exists() {
    local ret='0'
    type $1 >/dev/null 2>&1 || { local ret='1'; }

    # throw error on non-zero return value
    if [ ! "$ret" -eq '0' ]; then
        error "$2"
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

clone_repo() {
    if [ ! -e "$path_repo/.git" ]; then
        git clone --recursive -b "$git_branch" "$git_uri" "$path_repo"
        ret="$?"
        success "$1"
        debug
    else
        upgrade_repo "$app_name" "Successfully updated $app_name"
    fi

    if [ "$ret" -eq '0' ]; then
        "$path_repo/bootstrap.sh"
    fi
}

for app in {zsh,git,tmux}; do
    program_exists "$app"
done
unset app

clone_repo      "Successfully cloned $app_name"

msg             "\nThanks for installing $app_name."
msg             "© `date +%Y` $app_name"
