#!/usr/bin/env bash

APP_NAME='.dotfiles'
PATH_REPO="$HOME/$APP_NAME"

[ -r "$PATH_REPO/src/load.sh" ] && source "$PATH_REPO/src/load.sh"

function install_pyenv(){
    "$PATH_REPO/tools/pyenv/install.sh"
}

function install_gvm(){
    "$PATH_REPO/tools/gvm/install.sh"
}

function install_fonts(){
    "$PATH_REPO/tools/fonts/install.sh"
}

function install_tpm(){
    "$PATH_REPO/tools/tpm/install.sh"
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
    install_pyenv
    install_fonts
    install_tpm

    for path in "$PATH_REPO/"conf/{shell,app}; do
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

echo $TEST

if [[ $TEST = 'true']]; then
    initialize
    exit 1
fi

replace_files
