#!/usr/bin/env bash
# -*- coding: utf-8 -*-

ROOT="`pwd`"

export ROOT="`pwd`"

[ -r "$ROOT/src/load.sh" ] && source "$ROOT/src/load.sh"

function install_pyenv(){
    "$ROOT/tools/pyenv/install.sh"
}

function install_gvm(){
    "$ROOT/tools/gvm/install.sh"
}

function install_fonts(){
    "$ROOT/tools/fonts/install.sh"
}

function install_tpm(){
    "$ROOT/tools/tpm/install.sh"
}

function install_nvm(){
    "$ROOT/tools/nvm/install.sh"
}

function install_rvm(){
    "$ROOT/tools/rvm/install.sh"
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

    install_gvm
    install_nvm
    install_pyenv
    install_fonts
    install_tpm
    install_rvm

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

    msg "Copying file bashrc adding it to ~/.zshrc"

    echo  "[ -r ~/.bashrc ] && source ~/.bashrc" >> ~/.zshrc
}

clone_repo      "Successfully cloned $APP_NAME"

msg             "\nThanks for installing $APP_NAME."
msg             "© `date +%Y` $APP_NAME,s"

if [[ $TEST = 'true' ]]; then
    initialize
    exit 1
fi

replace_files
