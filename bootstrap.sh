#!/usr/bin/env bash
# -*- coding: utf-8 -*-

ROOT="`pwd`"

export ROOT="`pwd`"

[ -r "$ROOT/src/load.sh" ] && source "$ROOT/src/load.sh"

function install_apps(){
    "$ROOT/tools/pyenv/install.sh"
    "$ROOT/tools/gvm/install.sh"
    "$ROOT/tools/fonts/install.sh"
    "$ROOT/tools/tpm/install.sh"
    "$ROOT/tools/nvm/install.sh"
    "$ROOT/tools/rvm/install.sh"
    "$ROOT/tools/antigen/install.sh"
    "$ROOT/tools/tmux-themepack/install.sh"
}

function replace_files(){
    echo -n "This may overwrite existing files in your home directory. Are you sure? (y/n) "

    read response

    if [[ $response =~ ^[Yy]$ ]]; then
        initialize
    fi
}

function initialize(){
    for app in {zsh,git,tmux}; do
        program_exists "$app"
    done
    unset app

    install_apps

    for path in "$ROOT/"conf/{shell,app}; do
        for file_path in "$path/"*; do
            local file="$HOME/.${file_path##*/}"
            do_backup "$file"
            cp_file "$file_path" "$file"
            unset file
        done
        unset file_path
    done
    unset path

}

clone_repo      "Successfully cloned $APP_NAME"

msg             "\nThanks for installing $APP_NAME."
msg             "© `date +%Y` $APP_NAME,s"

if [[ $TEST = 'true' ]]; then
    initialize
    exit 1
fi

replace_files
